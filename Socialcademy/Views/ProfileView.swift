//
//  ProfileView.swift
//  Socialcademy
//
//  Created by Joel Alejandro Milla Lopez on 06/01/24.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    var body: some View {
        Button("Sign Out") {
            try! Auth.auth().signOut()
        }
    }
}

#Preview {
    ProfileView()
}
