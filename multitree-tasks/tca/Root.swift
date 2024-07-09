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
    @Dependency(\.uuid) var uuid

    @ObservableState
    struct State {
        var bag: TaskNodeBag<UUID>.State = .init()
        var selectedIDs: Set<UUID> = .init()
    }

    enum Action {
        case bag(TaskNodeBag<UUID>.Action)
        case selectedIDsChanged(Set<UUID>)
    }

    var body: some ReducerOf<Self> {
        Scope(state: \.bag, action: \.bag) {
            TaskNodeBag<UUID>(generator: uuid.callAsFunction)
        }
        Reduce { state, action in
            switch action {
            case .bag: return .none
            case .selectedIDsChanged(let ids):
                state.selectedIDs = ids
                return .none
            }
        }
    }
}
