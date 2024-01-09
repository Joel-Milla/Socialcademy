//
//  ProfileViewModel.swift
//  Socialcademy
//
//  Created by Joel Alejandro Milla Lopez on 08/01/24.
//

import Foundation

@MainActor
class ProfileViewModel: ObservableObject, ErrorHandler {
    @Published var name: String
    @Published var imageURL: URL? {
        didSet {
            imageURLDidChange(from: oldValue)
        }
    }
    @Published var error: Error?
    
    private let authService: AuthService
    
    init(name: String, imageURL: URL? = nil, error: Error? = nil, authService: AuthService) {
        self.name = name
        self.imageURL = imageURL
        self.error = error
        self.authService = authService
    }
    
    func signOut() {
        withErrorHandlingTask(perform: authService.signOut)
    }
    
    private func imageURLDidChange(from oldValue: URL?) {
        guard imageURL != oldValue else { return }
        withErrorHandlingTask { [self] in
            try await authService.updateProfileImage(to: imageURL)
        }
    }
}
