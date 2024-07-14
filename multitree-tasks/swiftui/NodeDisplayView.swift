//
//  NodeDisplayView.swift
//  multitree-tasks
//
//  Created by hung on 7/13/24.
//

import SwiftUI
import ComposableArchitecture

struct NodeDisplayView: View {
    @Bindable var store: StoreOf<Root>
    @Bindable var node: StoreOf<NodeDisplay<Root.ID>>
    @Environment(\.style) var style

    var body: some View {
        Group {
            let state = node.state
            let path = store.path
            let children = store.bag.tasks[id: state.id]!.childrenIDs
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
                    if let index = path.firstIndex(of: state) {
                        let selected: Set<Root.ID> = (path.count - 1 > index
                                                      ? .init([path[index + 1].id])
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
        .navigationDestination(item: $node.scope(state: \.destination?.add,
                                                 action: \.destination.add))
        { store in
            AddForm(store: store)
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

extension NodeDisplayView {
    struct AddForm: View {
        @Bindable var store: StoreOf<NodeDisplay<Root.ID>.AddForm>
        @Environment(\.style) var style

        var body: some View {
            Form {
                let count = store.repeatCount
                switch style {
                case .columns:
                    Group {
                        LabeledContent("Node Title") {
                            titleField
                        }
                        LabeledContent("Repeat \(count) Nodes") {
                            repeatCountSlider
                        }
                    }
                case .pages:
                    Group {
                        titleField
                        LabeledContent("\(count)x") {
                            repeatCountSlider
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Create", systemImage: "checkmark") {
                        store.send(.submitButtonTapped)
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", systemImage: "xmark", role: .cancel) {
                        store.send(.dismissButtonTapped)
                    }
                }
            }
            .navigationTitle("Node Creation")
        }

        var titleField: some View {
            TextField(text: $store.title, prompt: Text("Enter Title Here")) {
                Label("Node Title", systemImage: "textformat")
            }
        }

        @ViewBuilder
        var repeatCountSlider: some View {
            let binding = Binding<Float> {
                Float(store.repeatCount)
            } set: {
                store.send(.set(\.repeatCount, Int($0)))
            }
            Slider(value: binding, in: 1...100, step: 1) {
                Text("Repeat Counter")
            } minimumValueLabel: {
                Text("")
            } maximumValueLabel: {
                Text("100")
            }
        }
    }
}
