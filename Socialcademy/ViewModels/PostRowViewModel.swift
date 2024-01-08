//
//  PostRowViewModel.swift
//  Socialcademy
//
//  Created by Joel Alejandro Milla Lopez on 06/01/24.
//

import Foundation

@MainActor
@dynamicMemberLookup

class PostRowViewModel: ObservableObject, ErrorHandler {
    typealias Action = () async throws -> Void
    
    @Published var post: Post
    @Published var error: Error?
    
    private let deleteAction: Action?
    private let favoriteAction: Action
    var canDeletePost: Bool { deleteAction != nil }
    
    init(post: Post, error: Error? = nil, deleteAction: Action?, favoriteAction: @escaping Action) {
        self.post = post
        self.error = error
        self.deleteAction = deleteAction
        self.favoriteAction = favoriteAction
    }
    
    func deletePost() {
        guard let deleteAction = self.deleteAction else {
            preconditionFailure("Cannot delete post: no delete action provided")
        }
        withErrorHandlingTask(perform: deleteAction)
    }

    func favoritePost() {
        withErrorHandlingTask(perform: favoriteAction)
    }
    
    // Function to instead of using viewModel.post.content -> only use post.content
    subscript<T>(dynamicMember keyPath: KeyPath<Post, T>) -> T {
        post[keyPath: keyPath]
    }
}

