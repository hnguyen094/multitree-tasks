//
//  PagesView.swift
//  multitree-tasks
//
//  Created by hung on 7/13/24.
//

import SwiftUI
import ComposableArchitecture

struct PagesView: View {
    @Bindable var store: StoreOf<Root>
    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            SharedRootViews.NavigationRoot(store: store)
        } destination: { node in
            SharedRootViews.NodeDisplay(store: store, node: node, style: .pages)
                .toolbar {
                    SharedRootViews.SharedToolbar(store: store)
                }
                .navigationTitle(title)
        }
    }

    var title: String {
        if let lastID = store.path.last, let task = store.bag.tasks[id: lastID] {
            return task.detail.title
        }
        return ""
    }
}
