//
//  ContentView.swift
//  multitree-tasks
//
//  Created by hung on 7/3/24.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    @Bindable var store: StoreOf<Root>
    var body: some View {
        let bag = store.scope(state: \.bag, action: \.bag)
        let selectionBinding = $store.selectedIDs.sending(\.selectedIDsChanged)
        NavigationSplitView {
            List(bag.roots, id: \.self, selection: selectionBinding) { id in
                    Text(bag.tasks[id: id]!.detail.title)
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Add", systemImage: "plus") {
                        store.send(.addTaskRequest(true))
                    }
                }
            }
            .navigationTitle("Root")
        } detail: {
            DetailView(store: store)
        }
        .alert("Create Node", isPresented: $store.addTask.sending(\.addTaskRequest)) {
            TextField("Node Title", text: $store.workingTaskTitle.sending(\.changeWorkingTitle))
            Button("Create") {
                store.send(.addTask)
            }
            .disabled(store.workingTaskTitle.isEmpty)
            Button("Cancel", role: .cancel) {
                store.send(.addTaskRequest(false))
            }
        } message: {
            if let last = store.path.last {
                Text("Add a node to \"\(store.bag.tasks[id: last]!.detail.title).\"")
            } else {
                Text("Add a node to Root.")
            }
        }
    }
}

struct DetailView: View {
    @Bindable var store: StoreOf<Root>
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    var body: some View {
        switch horizontalSizeClass {
        case .compact: compact
        case .regular: regular
        default: fatalError()
        }
    }

    var compact: some View {
        Group {
            switch store.selectedIDs.count {
            case 0: Text("No node selected.")
            case 2... : Text("Too many nodes selected.")
            case 1:
                List(0..<10) { _ in
                    ScrollView {
                        List(0..<100) { i in
                            Text("Cool row item \(i)")
                        }
                    }
                }
            default: fatalError()
            }
        }        
        .navigationTitle(title)
    }

    var regular: some View {
        NavigationStack {
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(Array(store.path.enumerated()), id: \.offset) { index, id in
                        let children = store.bag.tasks[id: id]!.childrenIDs
                        switch children.isEmpty {
                        case true: 
                            Text("End of Branch")
                                .font(.headline)
                                .frame(idealWidth: 320, maxHeight: .infinity)
                        case false:
                            VStack {
                                let selected = store.path.count - 1 > index
                                ? Binding<Set<UUID>>.constant(.init([store.path[index+1]]))
                                : Binding<Set<UUID>>.constant(.init())
                                List(children, id: \.self, selection: selected) { id in
                                    Button(store.bag.tasks[id: id]!.detail.title) {
                                        store.send(.pathChanged(index, id))
                                    }
                                }
                                .listStyle(.plain)
                                .frame(idealWidth: 320, maxHeight: .infinity)
                                if children.count == 1 {
                                    Text("1 Node")
                                } else {
                                    Text("\(children.count) Nodes")
                                }
                            }
                        }
                        Divider()
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    LabeledContent("Root") {
                        Text(title)
                    }
                    .font(.headline)
                }
                ToolbarItem(placement: .primaryAction) {
                    Button("Add", systemImage: "plus") {
                        store.send(.addTaskRequest(true))
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button("Search", systemImage: "magnifyingglass") { }
                }
                if !store.path.isEmpty {
                    ToolbarItem(placement: .bottomBar) {
                        VStack {
                            Divider()
                            toolbarTaskDetail
                        }
                    }
                }
            }
        }
    }

    var title: String {
        switch store.selectedIDs.count {
        case 0: "None Selected"
        case let x where x > 1: "\(x) Selected"
        case 1: store.bag.tasks[id: store.selectedIDs.first!]!.detail.title
        default: "Error"
        }
    }

    @ViewBuilder
    var toolbarTaskDetail: some View {
        let task = store.bag.tasks[id: store.path.last!]!
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

#Preview {
    ContentView(store: .init(initialState: .init(), reducer: {
        Root()
    }))
}
