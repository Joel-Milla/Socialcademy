//
//  AuthView.swift
//  Socialcademy
//
//  Created by Joel Alejandro Milla Lopez on 06/01/24.
//

import SwiftUI

struct AuthView: View {
    @StateObject var authViewModel = AuthViewModel()

    var body: some View {
        if authViewModel.isAuthenticated {
            MainTabView()
        } else {
            Form {
                TextField("Email", text: $authViewModel.email)
                SecureField("Password", text: $authViewModel.password)
                Button("Sign In") {
                    authViewModel.signIn()
                }
            }
        }
    }
}

#Preview {
    AuthView()
}
