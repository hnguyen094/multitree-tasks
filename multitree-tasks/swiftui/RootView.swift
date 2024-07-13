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
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    var body: some View {
        Group {
            switch horizontalSizeClass {
            case .compact: PagesView(store: store)
            case .regular, .none: ColumnsView(store: store)
            @unknown default: PagesView(store: store)
            }
        }
        .alert("Create Node", isPresented: $store.addTask) {
            TextField("Node Title", text: $store.workingTaskTitle)
            Button("Create") {
                store.scope(state: \.path, action: \.path)
                    .send(.element(id: store.path.ids.last!, action: .addChild))
            }
            .disabled(store.workingTaskTitle.isEmpty)
            Button("Cancel", role: .cancel) {
                store.send(.set(\.addTask, false))
            }
        } message: {
            if let last = store.path.last, let task = store.bag.tasks[id: last] {
                Text("Add a node to **\(task.detail.title).**")
            } else {
                Text("Add a node to **Root**.")
            }
        }
    }

    // unused
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
