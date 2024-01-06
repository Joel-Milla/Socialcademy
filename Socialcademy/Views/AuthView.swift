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
            NavigationStack {
                SignIn(authViewModel: authViewModel.makeSignInViewModel()) {
                    NavigationLink("Create account") {
                        CreateAccount(authViewModel: authViewModel.makeCreateAccountViewModel())
                    }
                }
            }
        }
    }
}

// Sign in and create acocunt views
private extension AuthView {
    struct SignIn<Footer: View>: View {
        @StateObject var authViewModel: AuthViewModel.SignInViewModel
        @ViewBuilder let footer: () -> Footer
        
        var body: some View {
            Form {
                TextField("Email", text: $authViewModel.email)
                SecureField("Password", text: $authViewModel.password)
                Button("Sign In", action: authViewModel.submit)
                footer()
            }
            .navigationTitle("Sign In")
        }
    }

    struct CreateAccount: View {
        @StateObject var authViewModel: AuthViewModel.CreateAccountViewModel
        
        var body: some View {
            Form {
                TextField("Name", text: $authViewModel.name)
                TextField("Email", text: $authViewModel.email)
                SecureField("Password", text: $authViewModel.password)
                Button("Create Account", action: authViewModel.submit)
            }
            .navigationTitle("Create Account")
        }
    }
}

#Preview {
    AuthView()
}
