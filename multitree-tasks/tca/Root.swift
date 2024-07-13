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
    @ObservableState
    enum ID: Hashable {
        case uuid(UUID)
        case date(Date)
    }

    @Reducer
    struct StackDisplayFeature {
        typealias State = ID

        enum Action {
            case addChild
            case edit
            case move
            case selectChild(ID)
            // case delete
        }
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
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case path(StackActionOf<StackDisplayFeature>)

        case bag(TaskNodeBag<ID>.Action)
        case itemSelected(StackElementID, _ newID: ID)

        case addTask(_ parent: StackElementID?)
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
            case .addTask(let maybeParentStackID):
                @Dependency(\.uuid) var uuid
                let childID: ID = .uuid(uuid())
                let parentID: Root.ID? = switch maybeParentStackID {
                case let .some(parentStackID): state.path[id: parentStackID]
                case .none: .none
                }
                let detail: TaskNode<ID>.Detail = .init(title: state.workingTaskTitle)
                return .run { send in
                    await send(.bag(.create(childID, detail, parentID)))
                    await send(.set(\.scrollTargetColumn, childID))
                }
            case .path(.element(id: let parentStackID, action: .addChild)):
                return .send(.addTask(parentStackID))
            case let .path(.element(id: parentStackID, action: .selectChild(childID))):
                state.path.pop(to: parentStackID)
                state.path.append(childID)
                state.scrollTargetColumn = childID
                return .none
            case .bag, .binding, .path:
                return .none
            }
        }
        .forEach(\.path, action: \.path) {
            StackDisplayFeature()
        }
    }
}
