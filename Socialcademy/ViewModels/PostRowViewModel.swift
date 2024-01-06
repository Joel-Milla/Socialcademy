//
//  PostRowViewModel.swift
//  Socialcademy
//
//  Created by Joel Alejandro Milla Lopez on 06/01/24.
//

import Foundation

@MainActor
class PostRowViewModel: ObservableObject {
    typealias Action = () async throws -> Void
    
    @Published var post: Post
    @Published var error: Error?
    
    private let deleteAction: Action
    private let favoriteAction: Action
    
    init(post: Post, error: Error? = nil, deleteAction: @escaping Action, favoriteAction: @escaping Action) {
        self.post = post
        self.error = error
        self.deleteAction = deleteAction
        self.favoriteAction = favoriteAction
    }
}
