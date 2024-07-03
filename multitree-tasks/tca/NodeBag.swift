//
//  NodeBag.swift
//  multitree-tasks
//
//  Created by hung on 7/3/24.
//

import ComposableArchitecture

@Reducer
struct NodeBag<ID> where ID: Hashable {
    var generator: () -> ID

    @ObservableState struct State {
        var nodes: [ID: TaskNode<ID>.Detail] = [:]
    }

    enum Action {
        case add(TaskNode<ID>.Detail)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .add(let detail):
                state.nodes[generator()] = detail
                return .none
            }
        }
    }
}
