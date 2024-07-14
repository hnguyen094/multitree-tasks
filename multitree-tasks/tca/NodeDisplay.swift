//
//  NodeDisplay.swift
//  multitree-tasks
//
//  Created by hung on 7/13/24.
//

import ComposableArchitecture

@Reducer
struct NodeDisplay<ID> where ID: Hashable {
    @Reducer(state: .equatable)
    enum Destination {
        case add(AddForm)
    }

    @ObservableState
    struct State: Identifiable, Equatable {
        let id: ID

        @Presents var destination: Destination.State?
    }

    enum Action {
        case addChild
        case selectChild(ID)
        case destination(PresentationAction<Destination.Action>)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addChild:
                state.destination = .add(.init(parentID: state.id))
                return .none
            case .selectChild, .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

extension NodeDisplay {
    @Reducer
    struct AddForm {
        @ObservableState
        struct State: Equatable {
            let parentID: ID?
            var title: String = ""
            var repeatCount: Int = 1

            var detail: TaskNode<ID>.Detail {
                .init(title: self.title)
            }
        }

        enum Action: BindableAction {
            case binding(BindingAction<State>)
            case dismissButtonTapped
            case submitButtonTapped // parent handles submission and dismiss
        }

        @Dependency(\.dismiss) var dismiss
        var body: some ReducerOf<Self> {
            BindingReducer()
            Reduce { state, action in
                switch action {
                case .dismissButtonTapped:
                    return .run { _ in
                        await dismiss()
                    }
                case .submitButtonTapped, .binding:
                    return .none
                }
            }
        }
    }
}
