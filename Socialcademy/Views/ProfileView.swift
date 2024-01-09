//
//  ProfileView.swift
//  Socialcademy
//
//  Created by Joel Alejandro Milla Lopez on 06/01/24.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @StateObject var profileViewModel: ProfileViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                AsyncImage(url: profileViewModel.imageURL)
                    .frame(width: 200, height: 200)
                    .scaledToFit()
                    .clipShape(Circle())
                Spacer()
                Text(profileViewModel.user.name)
                    .font(.title2)
                    .bold()
                    .padding()
                ImagePickerButton(imageURL: $profileViewModel.imageURL) {
                    Label("Choose Image", systemImage: "photo.fill")
                }
                Spacer()
            }
            .navigationTitle("Profile")
            .toolbar {
                Button("Sign Out") {
                    profileViewModel.signOut()
                }
            }
        }
        .alert("Error", error: $profileViewModel.error)
        .disabled(profileViewModel.isWorking)
    }
}

#Preview {
    ProfileView(profileViewModel: ProfileViewModel(user: User.testUser, authService: AuthService()))
}
