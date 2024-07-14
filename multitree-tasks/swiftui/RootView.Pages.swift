//
//  RootView.Pages.swift
//  multitree-tasks
//
//  Created by hung on 7/13/24.
//

import SwiftUI
import ComposableArchitecture

extension RootView {
    struct Pages: View {
        @Bindable var store: StoreOf<Root>
        var body: some View {
            NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
                NavigationRoot(store: store)
            } destination: { node in
                NodeDisplayView(store: store, node: node)
                    .toolbar {
                        Toolbar(store: store, node: node)
                    }
                    .navigationTitle(title)
            }
            .environment(\.style, .pages)
        }

        var title: String {
            if let last = store.path.last, let task = store.bag.tasks[id: last.id] {
                return task.detail.title
            }
            return ""
        }
    }
}
