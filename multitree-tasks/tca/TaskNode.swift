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
    struct Detail: Hashable {
        var title: String
    }

    @ObservableState
    struct State: Identifiable, Hashable {
        var id: ID
        var childrenIDs: OrderedSet<ID> = .init()
        var detail: Detail

        var offspringIDs: Set<ID> = .init()
        var ancestorIDs: Set<ID> = .init()

        init(id: ID, detail: Detail) {
            self.id = id
            self.detail = detail
            offspringIDs.insert(id)
            ancestorIDs.insert(id)
        }
    }

    enum Action {
        case changeTitle(String)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .changeTitle(let newTitle):
                state.detail.title = newTitle
                return .none
            }
        }
    }
}
