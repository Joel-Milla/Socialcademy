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
        if let viewModelFactory = authViewModel.makeViewModelFactory() {
            MainTabView()
                .environmentObject(viewModelFactory)
        } else {
            NavigationStack {
                // Call the structure sign in, give the parameters, and give footer at the end.
                SignIn(signInViewModel: authViewModel.makeSignInViewModel()) {
                    NavigationLink("Create account") {
                        CreateAccount(createAccountViewModel: authViewModel.makeCreateAccountViewModel())
                    }
                }
            }
        }
    }
}

// Sign in and create acocunt views
private extension AuthView {
    // View for signin in
    struct SignIn<Footer: View>: View {
        @StateObject var signInViewModel: AuthViewModel.SignInViewModel
        @ViewBuilder let footer: () -> Footer
        
        var body: some View {
            Form {
                TextField("Email", text: $signInViewModel.email)
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
                SecureField("Password", text: $signInViewModel.password)
                    .textContentType(.password)
            } footer: {
                Button("Sign In", action: signInViewModel.submit)
                    .buttonStyle(.primary)
                footer()
                    .padding()
            }
            .alert("Cannot Sign In", error: $signInViewModel.error)
            .disabled(signInViewModel.isWorking)
        }
    }
    
    // View for creating the account
    struct CreateAccount: View {
        @StateObject var createAccountViewModel: AuthViewModel.CreateAccountViewModel
        @Environment(\.dismiss) private var dismiss
        
        var body: some View {
            Form {
                TextField("Name", text: $createAccountViewModel.name)
                    .textContentType(.name)
                    .textInputAutocapitalization(.words)
                TextField("Email", text: $createAccountViewModel.email)
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
                SecureField("Password", text: $createAccountViewModel.password)
                    .textContentType(.newPassword)
            } footer: {
                Button("Create Account", action: createAccountViewModel.submit)
                    .buttonStyle(.primary)
                Button("Sign In", action: dismiss.callAsFunction)
                    .padding()
            }
            .alert("Cannot Create Account", error: $createAccountViewModel.error)
            .disabled(createAccountViewModel.isWorking)
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

// Extension so instead of doing .buttonStyle(PrimaryButtonStyle()), we do -> .buttonStyle(.primary)
extension ButtonStyle where Self == PrimaryButtonStyle {
    static var primary: PrimaryButtonStyle {
        PrimaryButtonStyle()
    }
}

#Preview {
    AuthView()
}
