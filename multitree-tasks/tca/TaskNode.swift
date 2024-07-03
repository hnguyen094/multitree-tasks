//
//  TaskNode.swift
//  multitree-tasks
//
//  Created by hung on 7/3/24.
//

import ComposableArchitecture

import OrderedCollections

@Reducer
struct TaskNode<ID> where ID: Hashable {
    struct Detail: Equatable {

    }

    @ObservableState
    struct State: Equatable {
        var id: ID
        var children: OrderedSet<ID>
    }

    enum Action {
        case add(_ child: ID, _ position: Int?)
        case update(_ child: ID, _ position: Int)
        case remove(_ child: ID)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .add(child, maybePosition):
                // TODO: validate acyclic nature here
                let (success, index) = switch maybePosition {
                case .some(let position): state.children.insert(child, at: position)
                case .none: state.children.append(child)
                }
                return .none
            case let .update(child, position):
                state.children.update(child, at: position)
                return .none
            case .remove(let child):
                state.children.remove(child)
                return .none
            }
        }
    }
}
