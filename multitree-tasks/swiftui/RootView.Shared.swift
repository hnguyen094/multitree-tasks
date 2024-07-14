//
//  RootView.Shared.swift
//  multitree-tasks
//
//  Created by hung on 7/13/24.
//

import SwiftUI
import ComposableArchitecture

extension RootView {
    struct NavigationRoot: View {
        @Bindable var store: StoreOf<Root>

        var body: some View {
            List(selection: $store.selectedIDs) {
                Section("Root Nodes") {
                    ForEach(store.userRoots, id: \.self) { id in
                        Text(store.bag.tasks[id: id]!.detail.title)
                    }
                }
                Section("Dated") {
                    ForEach(store.dateRoots, id: \.self) { id in
                        if case .date(let date) = id {
                            Text(date, style: .date)
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Add", systemImage: "plus") {
                        store.send(.set(\.addRoot, .init(parentID: .none)))
                    }
                }

                ToolbarItem(placement: .primaryAction) {
                    Button("Debug Add", systemImage: "ladybug") {
                        store.send(.addTaskDebug(.none, .none))
                    }
                }
            }
            .navigationTitle("Home")
            .navigationDestination(item: $store.scope(state: \.addRoot, action: \.addRoot)) {
                NodeDisplayView.AddForm(store: $0)
            }
        }
    }

    struct Toolbar: ToolbarContent {
        @Bindable var store: StoreOf<Root>    
        @Bindable var node: StoreOf<NodeDisplay<Root.ID>>

        var body: some ToolbarContent {
            ToolbarItemGroup(placement: .primaryAction) {
                let path = store.path
                Button("Add One", systemImage: "plus") {
                    node.send(.addChild)
                }
                Button("Debug Add", systemImage: "ladybug") {
                    if let lastID = path.ids.last {
                        store.send(.addTaskDebug(lastID, .none))
                    }
                }
                Button("Search", systemImage: "magnifyingglass") { }
            }
            if let last = store.path.last, let task = store.bag.tasks[id: last.id] {
                ToolbarItem(placement: .bottomBar) {
                    VStack {
                        Divider()
                        HStack {
                            LabeledContent("Node") {
                                ScrollView(.horizontal) {
                                    Text(task.detail.title)
                                }
                            }
                            Spacer()
                            LabeledContent("ID") {
                                ScrollView(.horizontal) {
                                    Text("\(task.id)")
                                }
                            }
                        }
                        .scrollIndicators(.never)
                    }
                }
            }
        }
    }
}
