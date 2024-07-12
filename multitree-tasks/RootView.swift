//
//  RootView.swift
//  multitree-tasks
//
//  Created by hung on 7/3/24.
//

import SwiftUI
import ComposableArchitecture

struct RootView: View {
    @Bindable var store: StoreOf<Root>
    var body: some View {
        let bag = store.scope(state: \.bag, action: \.bag)
        NavigationSplitView {
            List(selection: $store.selectedIDs) {
                Section("Root Nodes") {
                    ForEach(bag.roots, id: \.self) { id in
                        Text(bag.tasks[id: id]!.detail.title)
                    }
                }
                Section("Dated") {
                    EmptyView()
                }
            }

            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Add", systemImage: "plus") {
                        store.send(.set(\.addTask, true))
                    }
                }

                ToolbarItem(placement: .primaryAction) {
                    Button("Cross", systemImage: "multiply") {
                        store.send(.set(\.workingTaskTitle, "Generated"))
                        store.send(.addTask)
                    }
                }
            }
            .navigationTitle("Home")
        } detail: {
            RootDetailView(store: store)
        }
        .alert("Create Node", isPresented: $store.addTask) {
            TextField("Node Title", text: $store.workingTaskTitle)
            Button("Create") {
                store.send(.addTask)
            }
            .disabled(store.workingTaskTitle.isEmpty)
            Button("Cancel", role: .cancel) {
                store.send(.set(\.addTask, false))
            }
        } message: {
            if let last = store.path.last {
                Text("Add a node to **\(store.bag.tasks[id: last]!.detail.title).**")
            } else {
                Text("Add a node to **Root**.")
            }
        }
    }

    @ViewBuilder
    var repeatCountSlider: some View {
        let binding = Binding<Float> {
            Float(store.repeatCount)
        } set: {
            store.send(.set(\.repeatCount, Int($0)))
        }
        Slider(value: binding, in: 1...100) {
            Text("Repeat")
        }
    }
}

#Preview {
    RootView(store: .init(initialState: .init(), reducer: {
        Root()
    }))
}
