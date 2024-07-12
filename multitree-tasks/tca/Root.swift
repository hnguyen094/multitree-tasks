//
//  Root.swift
//  multitree-tasks
//
//  Created by hung on 7/9/24.
//

import ComposableArchitecture
import Foundation

@Reducer
struct Root {
    enum ID: Hashable {
        case uuid(UUID)
        case date(Date)
    }

    @Reducer
    enum Destination {
        case add(Node<ID>.Create)
        case edit(Node<ID>.Edit)
        case move
    }

    @ObservableState
    struct State {
        var bag: TaskNodeBag<ID>.State = .init()
        var selectedIDs: Set<ID> = .init()
        var path: StackState<ID> = .init()

        var scrollTargetColumn: ID? = .none
        var addTask: Bool = false
        var workingTaskTitle: String = ""
        var repeatCount: Int = 1

        @Presents var destination: Destination.State?
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case destination(PresentationAction<Destination.Action>)

        case bag(TaskNodeBag<ID>.Action)
        case itemSelected(StackElementID, _ newID: ID)

        case addTask
    }

    var body: some ReducerOf<Self> {
        Scope(state: \.bag, action: \.bag) {
            TaskNodeBag<ID>()
        }
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(\.selectedIDs):
                let ids = state.selectedIDs
                state.path.removeAll()
                if ids.count == 1 {
                    state.path.append(ids.first!)
                }
                return .none
            case .itemSelected(let parentStackID, let id):
                state.path.pop(to: parentStackID)
                state.path.append(id)
                state.scrollTargetColumn = id
                return .none
            case .addTask:
                @Dependency(\.uuid) var uuid
                let id: ID = .uuid(uuid())
                return .concatenate(
                    .send(.bag(.create(id,
                                       .init(title: state.workingTaskTitle),
                                       state.path.last))),
                    .send(.set(\.scrollTargetColumn, id))
                )
            case .bag, .binding, .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}
