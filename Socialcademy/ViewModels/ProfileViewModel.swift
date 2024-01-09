//
//  ProfileViewModel.swift
//  Socialcademy
//
//  Created by Joel Alejandro Milla Lopez on 08/01/24.
//

import Foundation

@MainActor
class ProfileViewModel: ObservableObject, StateManager {
    @Published var user: User
    @Published var imageURL: URL? {
        didSet {
            imageURLDidChange(from: oldValue)
        }
    }
    @Published var error: Error?
    @Published var isWorking: Bool = false
    
    private let authService: AuthService
    
    init(user: User, imageURL: URL? = nil, error: Error? = nil, authService: AuthService) {
        self.user = user
        self.imageURL = imageURL
        self.error = error
        self.authService = authService
    }
    
    func signOut() {
        withStateManagingTask(perform: authService.signOut)
    }
    
    private func imageURLDidChange(from oldValue: URL?) {
        guard imageURL != oldValue else { return }
        withStateManagingTask { [self] in
            try await authService.updateProfileImage(to: imageURL)
        }
    }
}
