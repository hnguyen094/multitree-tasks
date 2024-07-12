//
//  Node.swift
//  multitree-tasks
//
//  Created by hung on 7/12/24.
//

import ComposableArchitecture
import OrderedCollections

@ObservableState
struct Node<ID>: Identifiable, Hashable where ID: Hashable {
    let id: ID
    var childrenIDs: OrderedSet<ID> = .init()

    var title: String = "<title>"
    var completed: Bool = false

    var offspringIDs: Set<ID> = .init()
    var ancestorIDs: Set<ID> = .init()

    init(id: ID) {
        self.id = id
        offspringIDs.insert(id)
        ancestorIDs.insert(id)
    }

    @Reducer
    struct Edit {
        typealias State = Node<ID>

        enum Action: BindableAction {
            case binding(BindingAction<State>)
        }

        var body: some ReducerOf<Self> {
            BindingReducer()
        }
    }

    @Reducer
    struct Create {
        typealias State = Node<ID>

        enum Action: BindableAction {
            case binding(BindingAction<State>)
        }

        var body: some ReducerOf<Self> {
            BindingReducer()
        }
    }
}
