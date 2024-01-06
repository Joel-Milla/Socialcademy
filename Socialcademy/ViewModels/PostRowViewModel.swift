//
//  PostRowViewModel.swift
//  Socialcademy
//
//  Created by Joel Alejandro Milla Lopez on 06/01/24.
//

import Foundation

@MainActor
@dynamicMemberLookup

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
    
    func deletePost() {
        withErrorHandlingTask(perform: deleteAction)
    }

    func favoritePost() {
        withErrorHandlingTask(perform: favoriteAction)
    }
    
    private func withErrorHandlingTask(perform action: @escaping Action) {
        Task {
            do {
                try await action()
            } catch {
                print("[PostRow] Unable to delete post: \(error)")
                self.error = error
            }
        }
    }
    
    // Function to instead of using viewModel.post.content -> only use post.content
    subscript<T>(dynamicMember keyPath: KeyPath<Post, T>) -> T {
        post[keyPath: keyPath]
    }
}

