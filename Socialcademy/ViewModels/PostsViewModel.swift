//
//  PostsViewModel.swift
//  Socialcademy
//
//  Created by Joel Alejandro Milla Lopez on 05/01/24.
//

import Foundation

@MainActor
class PostsViewModel: ObservableObject {
    @Published var posts: Loadable<[Post]> = .loading
    private let postsRepository: PostsRepositoryProtocol
    
    init(postsRepository: PostsRepositoryProtocol = PostsRepository()) {
        self.postsRepository = postsRepository
    }
    
    func fetchPosts() {
        Task {
            do {
                self.posts = .loaded(try await postsRepository.fetchAllPosts())
            } catch {
                print("[PostsViewModel] Cannot fetch posts: \(error)")
                posts = .error(error)
            }
        }
    }
    
    func makeCreateAction() -> NewPostForm.CreateAction {
        return {[weak self] post in
            try await self?.postsRepository.create(post)
            self?.posts.value?.insert(post, at: 0)
        }
    }
    
    func makePostRowViewModel(for post: Post) -> PostRowViewModel {
        return PostRowViewModel(post: post,
                                deleteAction: {[weak self] in
            try await self?.postsRepository.delete(post)
            self?.posts.value?.removeAll(where: {$0.id == post.id})
        },
                                favoriteAction: {[weak self] in
            try await self?.postsRepository.favoriteAction(post)
            guard let index = self?.posts.value?.firstIndex(of: post) else { return }
            self?.posts.value?[index].isFavorite.toggle()
        })
    }
}
