//
//  PrimaryButtonStyle.swift
//  Socialcademy
//
//  Created by Joel Alejandro Milla Lopez on 06/01/24.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    func makeBody(configuration: Configuration) -> some View {
        
        Group {
            if isEnabled {
                configuration.label
            } else {
                ProgressView()
            }
        }
            .padding()
            .frame(maxWidth: .infinity)
            .foregroundStyle(.white)
            .background(Color.accentColor)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .animation(.default, value: isEnabled)
    }
}
