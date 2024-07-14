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

    enum Style {
        case pages
        case columns
    }

    var body: some View {
        Group {
            switch horizontalSizeClass {
            case .compact: Pages(store: store)
            case .regular, .none: Columns(store: store)
            @unknown default: Pages(store: store)
            }
        }
    }
}

private struct StyleKey: EnvironmentKey {
    static let defaultValue: RootView.Style = .columns

}

extension EnvironmentValues {
    var style: RootView.Style {
        get { self[StyleKey.self] }
        set { self[StyleKey.self] = newValue }
    }
}

#Preview {
    RootView(store: .init(initialState: .init(), reducer: {
        Root()
    }))
}
