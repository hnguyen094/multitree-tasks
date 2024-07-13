//
//  SharedRootViews.swift
//  multitree-tasks
//
//  Created by hung on 7/13/24.
//

import SwiftUI
import ComposableArchitecture

struct SharedRootViews {
    enum Style {
        case pages
        case columns
    }

    struct NavigationRoot: View {
        @Bindable var store: StoreOf<Root>

        var body: some View {
            List(selection: $store.selectedIDs) {
                Section("Root Nodes") {
                    ForEach(store.bag.roots, id: \.self) { id in
                        Text(store.bag.tasks[id: id]!.detail.title)
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
                        store.send(.addTask(.none))
                    }
                }
            }
            .navigationTitle("Home")
        }
    }

    struct NodeDisplay: View {
        @Bindable var store: StoreOf<Root>
        @Bindable var node: StoreOf<Root.StackDisplayFeature>
        @State var style: Style

        var body: some View {
            let id = node.state
            let path = store.path
            let children = store.bag.tasks[id: id]!.childrenIDs
            switch children.count {
            case 0:
                let rotation: Double = switch style {
                case .pages: 0
                case .columns: 90
                }
                Text("End of Branch")
                    .font(.headline)
                    .rotationEffect(.degrees(rotation))
            case let count:
                VStack {
                    if let index = path.firstIndex(of: id) {
                        let selected: Set<Root.ID> = (path.count - 1 > index
                                                      ? .init([path[index + 1]])
                                                      : .init())
                        List(children, id: \.self, selection: .constant(selected)) { id in
                            item(id: id)
                        }
                        .listStyle(.plain)
                        .frame(idealWidth: 320, maxHeight: .infinity)

                        let text = switch count {
                        case 1: "1 Node"
                        default: "\(count) Nodes"
                        }
                        Text(text)
                            .font(.headline)
                    }
                }
            }
        }

        @ViewBuilder
        func item(id: Root.ID) -> some View {
            Button {
                node.send(.selectChild(id), animation: .default)
            } label: {
                let task = store.bag.tasks[id: id]!
                HStack {
                    let children = store.bag.tasks[id: id]!.childrenIDs
                        .map({ store.bag.tasks[id: $0]! })
                    let sources = Binding<[TaskNode<Root.ID>.State]>.constant(children)
                    Toggle(sources: sources, isOn: \.detail.completed) {
                        Text("Completed")
                    }
                    .toggleStyle(CheckboxStyle())
                    Text(task.detail.title)
                    Spacer()
                    Text("(\(task.offspringIDs.count - 1))")
                }
            }
        }
    }

    struct SharedToolbar: ToolbarContent {
        @Bindable var store: StoreOf<Root>

        var body: some ToolbarContent {
            ToolbarItemGroup(placement: .primaryAction) {
                let path = store.path
                Button("Add One", systemImage: "plus") {
                    store.send(.set(\.addTask, true))
                }
                Button("Cross", systemImage: "multiply") {
                    store.send(.set(\.workingTaskTitle, "Generated"))
                    if let lastID = path.ids.last {
                        store.scope(state: \.path, action: \.path)
                            .send(.element(id: lastID, action: .addChild))
                    }
                }
                Button("Add Multiple", systemImage: "plus.square.on.square") {
                }
                Button("Search", systemImage: "magnifyingglass") { }
            }
            if let lastID = store.path.last, let task = store.bag.tasks[id: lastID] {
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

//    struct AddTaskFormView: View {
//        @Bindable var store: StoreOf<AddTaskForm>
//
//        var body: some View {
//            List {
//                LabeledContent("Title") {
//                    TextField("Title", text: $store.title)
//                }
//            }
//            .toolbar {
//                ToolbarItem(placement: .primaryAction) {
//                    Button("Create", systemImage: "checkmark") {
//                        store.send(.submitButtonTapped)
//                    }
//                }
//                ToolbarItem(placement: .cancellationAction) {
//                    Button("Cancel", systemImage: "xmark", role: .cancel) {
//                        store.send(.dismissButtonTapped)
//                    }
//                }
//            }
//            .navigationTitle("Node Creation")
//        }
//    }
}
