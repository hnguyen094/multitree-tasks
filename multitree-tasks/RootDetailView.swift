//
//  RootDetailView.swift
//  multitree-tasks
//
//  Created by hung on 7/11/24.
//

import SwiftUI
import ComposableArchitecture

struct RootDetailView: View {
    @Bindable var store: StoreOf<Root>
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    var body: some View {
        columns
    }

    @ViewBuilder
    var stack: some View {
        Group {
            switch store.selectedIDs.count {
            case 0: Text("No node selected.")
            case 2... : Text("Too many nodes selected.")
            case 1:
                let selectedTask = store.bag.tasks[id: store.selectedIDs.first!]!
                List(selectedTask.childrenIDs, id: \.self) { id in
                    Text(store.bag.tasks[id: id]!.detail.title)
                }
            default: fatalError()
            }
        }
        .navigationTitle(title)
    }

    @ViewBuilder
    var columns: some View {
        NavigationStack {
            ScrollView(.horizontal) {
                HStack(spacing: 0) {
                    ForEach(Array(store.path.enumerated()), id: \.offset) { index, id in
                        column(column: index, id: id)
                        Divider()
                    }
                }
                .scrollTargetLayout()
            }
            .scrollPosition(id: $store.scrollTargetColumn.sending(\.scrollTargetChanged), anchor: .bottomTrailing)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    LabeledContent("Root") {
                        Text(title)
                    }
                    .font(.headline)
                }

                ToolbarItemGroup(placement: .primaryAction) {

                    Button("Add One", systemImage: "plus") {
                        store.send(.addTaskRequest(true))
                    }
                    Button("Cross", systemImage: "multiply") {
                        store.send(.changeWorkingTitle("Generated"))
                        store.send(.addTask)
                    }
                    Button("Add Multiple", systemImage: "plus.square.on.square") {
//                        store.send(.addTaskRequest(true))
                    }
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
    func column(column: Int, id: Root.ID) -> some View {
        let children = store.bag.tasks[id: id]!.childrenIDs
        switch children.count {
        case 0:
            Text("End of Branch")
                .font(.headline)
                .rotationEffect(.degrees(90))
        case let count:
            VStack {
                let selected: Set<Root.ID> = (store.path.count - 1 > column
                                           ? .init([store.path[column + 1]]): .init())

                List(children, id: \.self, selection: .constant(selected)) { id in
                    item(column: column, id: id)
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

    @ViewBuilder
    func item(column: Int, id: Root.ID) -> some View {
        Button {
            store.send(.pathChanged(column, id), animation: .easeOut)
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
    }
}
