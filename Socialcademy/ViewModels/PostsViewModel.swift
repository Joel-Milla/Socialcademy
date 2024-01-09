//
//  PostsViewModel.swift
//  Socialcademy
//
//  Created by Joel Alejandro Milla Lopez on 05/01/24.
//

import Foundation

@MainActor
// This class contains the posts and the functions in charge of interacting with the repository to get the posts.
class PostsViewModel: ObservableObject {
    @Published var posts: Loadable<[Post]> = .loading
    private let filter: Filter
    private let postsRepository: PostsRepositoryProtocol
    
    var title: String {
        switch filter {
        case .all:
            return "Posts"
        case .favorites:
            return "Favorites"
        case let .author(author):
            return "\(author.name)'s Posts"
        }
    }
    
    init(filter: Filter = .all, postsRepository: PostsRepositoryProtocol) {
        self.filter = filter
        self.postsRepository = postsRepository
    }

    
    func fetchPosts() {
        Task {
            do {
                self.posts = .loaded(try await postsRepository.fetchPosts(matching: filter))
            } catch {
                print("[PostsViewModel] Cannot fetch posts: \(error)")
                posts = .error(error)
            }
        }
    }
    
    func makeNewPostViewModel() -> FormViewModel<Post> {
        return FormViewModel(initialValue: Post(title: "", content: "", author: postsRepository.user), action: {
            [weak self] post in
            try await self?.postsRepository.create(post)
            self?.posts.value?.insert(post, at: 0)
        })
    }
    
    func makePostRowViewModel(for post: Post) -> PostRowViewModel {
        let deleteAction = { [weak self] in
            try await self?.postsRepository.delete(post)
            self?.posts.value?.removeAll { $0 == post }
        }
        
        let favoriteAction = { [weak self] in
            try await self?.postsRepository.favoriteAction(post)
            guard let index = self?.posts.value?.firstIndex(of: post) else { return }
            self?.posts.value?[index].isFavorite.toggle()
            
            // update number of likes
            guard let isFavorite = self?.posts.value?[index].isFavorite else { return }
            if isFavorite {
                self?.posts.value?[index].numberOfLikes += 1
            } else {
                self?.posts.value?[index].numberOfLikes -= 1
            }
        }
        return PostRowViewModel(post: post,
                                deleteAction: postsRepository.canDelete(post) ? deleteAction : nil,
                                favoriteAction: favoriteAction)
    }
}

extension PostsViewModel {
    enum Filter {
        case all, author(User), favorites
    }
}

// Extension that calls the correct method from the protocol given the filter.
private extension PostsRepositoryProtocol {
    func fetchPosts(matching filter: PostsViewModel.Filter) async throws -> [Post] {
        switch filter {
        case .all:
            try await fetchAllPosts()
        case .favorites:
            try await fetchFavoritePosts()
        case let .author(author):
            try await fetchPosts(by: author)
        }
    }
}
