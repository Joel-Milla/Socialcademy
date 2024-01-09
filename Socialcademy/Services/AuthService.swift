//
//  AuthService.swift
//  Socialcademy
//
//  Created by Joel Alejandro Milla Lopez on 06/01/24.
//

import Foundation
import FirebaseAuth

@MainActor
class AuthService: ObservableObject {
    @Published var user: User?
    
    private let auth = Auth.auth()
    private var listener: AuthStateDidChangeListenerHandle?
    private var name = ""
    
    init() {
        // this variable listens to the changes on the user authentication and assigns the current user to the property user of AuthService. The user after the _, is the user saved in the firebaseToken (the displayName, userID, emailVerified, etc.. and all the metadata.
        listener = auth.addStateDidChangeListener({ _, firebaseUser in
            if let firebaseUser = firebaseUser {
                if !self.name.isEmpty {
                    self.user = User(from: firebaseUser, name: self.name)
                } else {
                    self.user = User(from: firebaseUser)
                }
            } else {
                // Handle the scenario where firebaseUser is nil
                self.user = nil // or some default initialization
            }
        })
    }
    
    func createAccount(name: String, email: String, password: String) async throws {
        self.name = name
        let result = try await auth.createUser(withEmail: email, password: password)
        try await result.user.updateProfile(\.displayName, to: name)
    }
    
    func signIn(email: String, password: String) async throws {
        try await auth.signIn(withEmail: email, password: password)
    }
    
    func signOut() throws {
        try auth.signOut()
    }
    
    func updateProfileImage(to imageFileURL: URL?) async throws {
        guard let user = auth.currentUser else {
            preconditionFailure("Cannot update profile for nil user")
        }
        guard let imageFileURL = imageFileURL else {
            // if call the method with nil url, delete the profile picture
            try await user.updateProfile(\.photoURL, to: nil)
            if let photoURL = user.photoURL {
                try await StorageFile.atURL(photoURL).delete()
            }
            let userImage = StorageFile
                .with(namespace: "users", identifier: user.uid)
            try await userImage.delete()
            return
        }
        async let newPhotoURL = StorageFile
            .with(namespace: "users", identifier: user.uid)
            .putFile(from: imageFileURL)
            .getDownloadURL()
        try await user.updateProfile(\.photoURL, to: newPhotoURL)
    }
}

// Extension to update user's profile with information such as the name
private extension FirebaseAuth.User {
    func updateProfile<T>(_ keyPath: WritableKeyPath<UserProfileChangeRequest, T>, to newValue: T) async throws {
        var profileChangeRequest = createProfileChangeRequest()
        profileChangeRequest[keyPath: keyPath] = newValue
        try await profileChangeRequest.commitChanges()
    }
}

private extension User {
    init(from firebaseUser: FirebaseAuth.User, name: String? = nil) {
        self.id = firebaseUser.uid
        self.name = firebaseUser.displayName ?? name ?? "Unknown"
        self.imageURL = firebaseUser.photoURL
    }
}
