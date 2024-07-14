//
//  RootView.Columns.swift
//  multitree-tasks
//
//  Created by hung on 7/13/24.
//

import SwiftUI
import ComposableArchitecture

extension RootView {
    struct Columns: View {
        @Bindable var store: StoreOf<Root>
        var body: some View {
            NavigationSplitView {
                NavigationRoot(store: store)
            } detail: {
                Group {
                    switch store.selectedIDs.count {
                    case 0: Text("No node selected.")
                    case 2... : Text("Many nodes selected.")
                    case 1: detail
                    default: fatalError()
                    }
                }
            }
            .environment(\.style, .columns)
        }

        var detail: some View {
            NavigationStack {
                ScrollView(.horizontal) {
                    HStack(spacing: 0) {
                        let path = store.path
                        ForEach(path.ids, id: \.self) { stackID in
                            if let nodeStore = store.scope(state: \.path[id: stackID],
                                                           action: \.path[id: stackID]) {
                                NodeDisplayView(store: store, node: nodeStore)
                                Divider()
                            }
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollPosition(id: $store.scrollTargetColumn, anchor: .bottomTrailing)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        LabeledContent("Root") {
                            let title = switch store.selectedIDs.count {
                            case 0: "None Selected"
                            case let x where x > 1: "\(x) Selected"
                            case 1: store.bag.tasks[id: store.selectedIDs.first!]!.detail.title
                            default: "Error"
                            }
                            Text(title)
                        }
                        .font(.headline)
                    }

                    if let lastID = store.path.ids.last,
                       let node = store.scope(state: \.path[id: lastID], action: \.path[id: lastID])
                    {
                        Toolbar(store: store, node: node)
                    }
                }
            }
        }
    }
}
