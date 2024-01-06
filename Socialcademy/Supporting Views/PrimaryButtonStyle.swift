//
//  PrimaryButtonStyle.swift
//  Socialcademy
//
//  Created by Joel Alejandro Milla Lopez on 06/01/24.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .foregroundStyle(.white)
            .background(Color.accentColor)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
