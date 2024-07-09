//
//  multitree_tasksApp.swift
//  multitree-tasks
//
//  Created by hung on 7/3/24.
//

import SwiftUI
import ComposableArchitecture

@main
struct multitree_tasksApp: App {
    var store: StoreOf<Root> = .init(initialState: .init()) {
        Root()
    }
    var body: some Scene {
        WindowGroup {
            ContentView(store: store)
        }
    }
}
