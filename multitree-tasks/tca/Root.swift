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

    enum ID: Hashable {
        case uuid(UUID)
        case date(Date)
    }

    @ObservableState
    struct State {
        var bag: TaskNodeBag<ID>.State = .init()
        var selectedIDs: Set<ID> = .init()
        var path: [ID] = .init()

        var scrollTargetColumn: Int? = .none

        var addTask: Bool = false
        var workingTaskTitle: String = ""
        var repeatCount: Int = 1
    }

    enum Action {
        case bag(TaskNodeBag<ID>.Action)
        case selectedIDsChanged(Set<ID>)
        case pathChanged(_ column: Int, ID)

        case scrollTargetChanged(Int?)

        case addTaskRequest(Bool)
        case changeWorkingTitle(String)
        case changeRepeatCount(Int)
        case addTask
    }

    var body: some ReducerOf<Self> {
        Scope(state: \.bag, action: \.bag) {
            TaskNodeBag<ID>(generator: { .uuid(uuid()) })
        }
        Reduce { state, action in
            switch action {
            case .bag: return .none
            case .selectedIDsChanged(let ids):
                state.selectedIDs = ids
                if ids.count == 1 {
                    state.path = [ids.first!]
                } else {
                    state.path = []
                }
                return .none
            case .pathChanged(let column, let id):
                state.path.removeSubrange(column+1..<state.path.count)
                state.path.append(id)
                state.scrollTargetColumn = state.path.count - 1
                return .none
            case .scrollTargetChanged(let newValue):
                state.scrollTargetColumn = newValue
                return .none
            case .addTaskRequest(let show):
                state.addTask = show
                return .none
            case .changeWorkingTitle(let title):
                state.workingTaskTitle = title
                return .none
            case .changeRepeatCount(let repeatCount):
                state.repeatCount = repeatCount
                return .none
            case .addTask:
                state.scrollTargetColumn = state.path.count - 1
                return .send(.bag(.create(.init(title: state.workingTaskTitle), state.path.last)))
            }

        }
    }
}
