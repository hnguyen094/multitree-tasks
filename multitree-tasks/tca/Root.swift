//
//  Root.swift
//  multitree-tasks
//
//  Created by hung on 7/9/24.
//

import ComposableArchitecture
import OrderedCollections
import Foundation

@Reducer
struct Root {
    enum ID: Hashable {
        case uuid(UUID)
        case date(Date)
    }

    @ObservableState
    struct State {
        var bag: TaskNodeBag<ID>.State = .init()
        var path: StackState<NodeDisplay<ID>.State> = .init()
        @Presents var addRoot: NodeDisplay<ID>.AddForm.State?

        var selectedIDs: Set<ID> = .init()
        var scrollTargetColumn: ID? = .none

        var userRoots: OrderedSet<ID> {
            bag.roots.filter {
                switch $0 {
                case .uuid: true
                default: false
                }
            }
        }
        var dateRoots: OrderedSet<ID> {
            bag.roots.filter {
                switch $0 {
                case .date: true
                default: false
                }
            }
        }
    }

    enum Action: BindableAction {
        case bag(TaskNodeBag<ID>.Action)
        case path(StackActionOf<NodeDisplay<ID>>)
        case addRoot(PresentationAction<NodeDisplay<ID>.AddForm.Action>)

        case binding(BindingAction<State>)

        case addTask(_ parent: StackElementID?, _ detail: TaskNode<ID>.Detail)
        case addTaskDebug(_ parent: StackElementID?, _ customID: ID?)
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
                    state.path.append(.init(id: ids.first!))
                }
                return .none
            case .addTask(let maybeParentStackID, let detail):
                @Dependency(\.uuid) var uuid
                let childID: ID = .uuid(uuid())
                let parentID: Root.ID? = switch maybeParentStackID {
                case let .some(parentStackID): state.path[id: parentStackID]?.id
                case .none: .none
                }
                return .run { send in
                    await send(.bag(.create(childID, detail, parentID)))
                    await send(.set(\.scrollTargetColumn, childID))
                }
            case let .path(.element(id: parentStackID, action: .selectChild(childID))):
                state.path.pop(to: parentStackID)
                state.path.append(.init(id: childID))
                state.scrollTargetColumn = childID
                return .none
            case .addTaskDebug(let parentStackID, let maybeCustomID):
                @Dependency(\.uuid) var uuid
                let childID: ID = maybeCustomID ?? .uuid(uuid())
                let parentID: Root.ID? = switch parentStackID {
                case let .some(parentStackID): state.path[id: parentStackID]?.id
                case .none: .none
                }
                let detail: TaskNode<ID>.Detail = .init(title: "Generated")
                return .run { send in
                    await send(.bag(.create(childID, detail, parentID)))
                    await send(.set(\.scrollTargetColumn, childID))
                }
            case .bag, .binding, .path, .addRoot:
                return .none
            }
        }
        .ifLet(\.$addRoot, action: \.addRoot) {
            NodeDisplay<ID>.AddForm()
        }
        .forEach(\.path, action: \.path) {
            NodeDisplay<ID>()
        }
        submissionReducer
    }

    var submissionReducer: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addRoot(.presented(.submitButtonTapped)):
                guard case .some(let formData) = state.addRoot else {
                    return .none
                }
                state.addRoot = .none
                return .run { send in
                    for i in 0..<formData.repeatCount {
                        await send(.addTask(.none, formData.detail))
                    }
                }
            case .path(.element(id: let parentStackID,
                                action: .destination(.presented(.add(.submitButtonTapped))))):
                guard case .some(.add(let formData)) = state.path[id: parentStackID]?.destination
                else { return .none }
                state.path[id: parentStackID]?.destination = .none

                return .run { send in
                    for i in 0..<formData.repeatCount {
                        await send(.addTask(parentStackID, formData.detail))
                    }
                }
            default: return .none
            }
        }
    }
}
