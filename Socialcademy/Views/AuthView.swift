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
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
                SecureField("Password", text: $authViewModel.password)
                    .textContentType(.password)
            } footer: {
                Button("Sign In", action: authViewModel.submit)
                    .buttonStyle(PrimaryButtonStyle())
                footer()
                    .padding()
            }
        }
    }
    
    struct CreateAccount: View {
        @StateObject var authViewModel: AuthViewModel.CreateAccountViewModel
        
        var body: some View {
            Form {
                TextField("Name", text: $authViewModel.name)
                    .textContentType(.name)
                    .textInputAutocapitalization(.words)
                TextField("Email", text: $authViewModel.email)
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
                SecureField("Password", text: $authViewModel.password)
                    .textContentType(.newPassword)
            } footer: {
                Button("Create Account", action: authViewModel.submit)
                    .buttonStyle(PrimaryButtonStyle())
            }
        }
    }
}

// Has the form that is used for sign in and create account
private extension AuthView {
    struct Form<Content: View, Footer: View>:View {
        @ViewBuilder let content: () -> Content
        @ViewBuilder let footer: () -> Footer
        
        var body: some View {
            VStack {
                Text("Socialacademy")
                    .font(.title.bold())
                content()
                    .padding()
                    .background(Color.secondary.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                footer()
            }
            .toolbar(.hidden)
            .padding()
        }
    }
}

#Preview {
    AuthView()
}
