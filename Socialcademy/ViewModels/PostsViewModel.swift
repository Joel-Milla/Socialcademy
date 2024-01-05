//
//  PostsViewModel.swift
//  Socialcademy
//
//  Created by Joel Alejandro Milla Lopez on 05/01/24.
//

import Foundation

@MainActor
class PostsViewModel: ObservableObject {
    @Published var posts = [Post.testPost]
    
    func createPost(_ post: Post) {
        self.posts.insert(post, at: 0)
    }
    
    func makeCreateAction() -> NewPostForm.CreateAction {
        return {[weak self] post in
            self?.posts.insert(post, at: 0)
        }
    }
}
