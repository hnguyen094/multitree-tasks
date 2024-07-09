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
                VStack {
                    Text(bag.tasks[id: id]!.detail.title)
                    Text("\(id)")
                }
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Add", systemImage: "plus") {
                        bag.send(.create(.init(title: "test")))
                    }
                }
            }
            .navigationTitle("Multitree")
        } detail: {
            DetailView(store: store)
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
            case 0: Text("No task selected.")
            case 2... : Text("Too many tasks selected.")
            case 1:
                List(0..<10) { _ in
                    ScrollView {
                        List(0..<100) { i in
                            Text("Cool row item \(i)")
                        }
                    }
                }
                Text("Showing \(store.bag.tasks[id: store.selectedIDs.first!]!.detail.title)")
            default: fatalError()
            }
        }        
        .navigationTitle("<Current Scope>")
        .navigationBarTitleDisplayMode(.inline)
    }

    var regular: some View {
        NavigationStack {
            VStack {
                Divider()
                    .padding(.horizontal, -100)
                ScrollView(.horizontal) {
                    LazyHStack {
                        ForEach(0..<10) { _ in
                            List(0..<10) {
                                Text("blah blah \($0)")
                            }
                            .listStyle(.plain)
                            .frame(idealWidth: 320, maxHeight: .infinity)
                            Divider()
                        }
                    }
                }
            }
            .toolbarBackgroundVisibility(.visible, for: .automatic)
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button("Back", systemImage: "chevron.left") { }
                        .disabled(true)
                }
                ToolbarItem(placement: .navigation) {
                    Button("Forward", systemImage: "chevron.right") { }
                        .disabled(true)
                }
                ToolbarItem(placement: .navigation) {
                    Text("<Current Scope>")
                        .font(.headline)
                }
                ToolbarItem(placement: .primaryAction) {
                    Button("Select") { }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button("Add", systemImage: "plus") { }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button("Search", systemImage: "magnifyingglass") { }
                }
            }
        }
    }
}

#Preview {
    ContentView(store: .init(initialState: .init(), reducer: {
        Root()
    }))
}
