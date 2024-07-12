//
//  TaskNodeBag.swift
//  multitree-tasks
//
//  Created by hung on 7/3/24.
//

import ComposableArchitecture
import OrderedCollections

@Reducer
struct TaskNodeBag<ID> where ID: Hashable {
    @ObservableState 
    struct State {
        var tasks: IdentifiedArrayOf<TaskNode<ID>.State> = .init()
        var roots: OrderedSet<ID> = .init()
    }

    enum Action {
        case create(ID, TaskNode<ID>.Detail, _ parent: ID?)
        case link(_ parent: ID, _ child: ID)
        case markCompleted(ID, Bool)
        case tasks(IdentifiedActionOf<TaskNode<ID>>)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .create(let id, let detail, let maybeParent):
                let task: TaskNode<ID>.State = .init(id: id, detail: detail)
                state.tasks.append(task)
                if let parent = maybeParent {
                    return .send(.link(parent, id))
                }
                state.roots.append(id)
                return .none
            case .link(let parent, let child):
                if validate(state, source: parent, destination: child) {
                    link(&state, parent: parent, child: child)
                }
                state.roots.remove(child)
                return .none
            case .markCompleted(let id, let completed):
                markComplete(&state, id: id, completed: completed)
                return .none
            case .tasks:
                return .none
            }
        }
        .forEach(\.tasks, action: \.tasks) {
            TaskNode<ID>()
        }
    }

    // TODO: is this correct?
    func validate(_ state: State, source: ID, destination: ID) -> Bool {
        guard source != destination,
              let sourceNode = state.tasks[id: source],
              let destinationNode = state.tasks[id: destination] 
        else {
            return false
        }

        guard !(sourceNode.ancestorIDs.contains(destination) ||
                sourceNode.offspringIDs.contains(destination) ||
                destinationNode.ancestorIDs.contains(source) ||
                destinationNode.offspringIDs.contains(source)) 
        else {
            return false
        }

        return sourceNode.offspringIDs.intersection(destinationNode.offspringIDs).isEmpty &&
                sourceNode.ancestorIDs.intersection(destinationNode.ancestorIDs).isEmpty
    }

    // TODO: needs to handle reparenting also.
    func link(_ state: inout State, parent: ID, child: ID) {
        let parentNode = state.tasks[id: parent]!, childNode = state.tasks[id: child]!
        for ancestor in parentNode.ancestorIDs {
            state.tasks[id: ancestor]!.offspringIDs.formUnion(childNode.offspringIDs)
        }
        for offspring in childNode.offspringIDs {
            state.tasks[id: offspring]!.ancestorIDs.formUnion(parentNode.ancestorIDs)
        }
        state.tasks[id: parent]!.childrenIDs.append(child)
    }

    func markComplete(_ state: inout State, id: ID, completed: Bool) {
        for child in state.tasks[id: id]!.offspringIDs {
            state.tasks[id: child]!.detail.completed = completed
        }
        state.tasks[id: id]!.detail.completed = completed
    }

    func applyDownwardsRecursive(_ state: inout State,
                               next current: ID,
                               action: @escaping (inout TaskNode<ID>.State) -> Void
    ) {
        action(&state.tasks[id: current]!)
        for child in state.tasks[id: current]!.childrenIDs {
            applyDownwardsRecursive(&state, next: child, action: action)
        }
    }
}
