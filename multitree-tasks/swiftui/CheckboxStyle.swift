//
//  CheckboxStyle.swift
//  multitree-tasks
//
//  Created by hung on 7/11/24.
//
//  https://stackoverflow.com/a/65895802

import SwiftUI

struct CheckboxStyle: ToggleStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        return Button {
            configuration.isOn.toggle()
        } label: {
            Image(systemName: configuration.isMixed ? "minus.square.fill"
                  : configuration.isOn ? "checkmark.square.fill"
                  : "square")
        }
    }
}
