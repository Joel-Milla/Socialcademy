//
//  PostsRepository.swift
//  Socialcademy
//
//  Created by Joel Alejandro Milla Lopez on 05/01/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

// This file has the functions that connect with the database.
protocol PostsRepositoryProtocol {
    func create(_ post: Post) async throws
    func fetchAllPosts() async throws -> [Post]
    func delete(_ post: Post) async throws
    func favoriteAction(_ post: Post) async throws
    func fetchFavoritePosts() async throws -> [Post]
    var user: User { get }
    func fetchPosts(by author: User) async throws -> [Post]
}

struct PostsRepository: PostsRepositoryProtocol {
    let postsReference = Firestore.firestore().collection("posts")
    let favoritesReference = Firestore.firestore().collection("favorites")
    
    func create(_ post: Post) async throws {
        let document = postsReference.document(post.id.uuidString)
        try await document.setData(from: post)
    }
    
    func fetchAllPosts() async throws -> [Post] {
        let query = postsReference
            .order(by: "timestamp", descending: true)
        return try await fetchPosts(from: query)
    }
    
    func delete(_ post: Post) async throws {
        precondition(canDelete(post))
        let document = postsReference.document(post.id.uuidString)
        try await document.delete()
    }
    
    func favoriteAction(_ post: Post) async throws {
        let favorite = Favorite(postID: post.id, userID: user.id)
        let document = favoritesReference.document(favorite.id)
        if post.isFavorite {
            try await document.delete()
        } else {
            try await document.setData(from: favorite)
        }
    }
    
    // Call the favorite posts of the current user in favorites (that contains the post id and author id...
    // , and if it is not empty, then it fetches the posts content from postReference ...
    // Then it returns the posts with the isFavorite variable with trye.
    func fetchFavoritePosts() async throws -> [Post] {
        let favorites = try await fetchFavorites()
        guard !favorites.isEmpty else { return [] }
        let posts = try await postsReference
            .whereField("id", in: favorites.map(\.uuidString))
            .order(by: "timestamp", descending: true)
            .getDocuments(as: Post.self)
        return posts.map { post in
            post.setting(\.isFavorite, to: true)
        }
    }
    
    let user: User
    
    func fetchPosts(by author: User) async throws -> [Post] {
        let query = postsReference
            .order(by: "timestamp", descending: true)
            .whereField("author.id", isEqualTo: author.id)
        return try await fetchPosts(from: query)
    }
}

// Precondition to know if can delete the post
extension PostsRepositoryProtocol {
    func canDelete(_ post: Post) -> Bool {
        post.author.id == user.id
    }
}

// Extension of PostsRepository to fetch the correct favorite posts.
private extension PostsRepository {
    // fetch the posts of an author from posts and fetches favorites...
    // then it returns the posts but if the post exist in favorites, save the variable...
    // isFavorite as true. If not, then false.
    private func fetchPosts(from query: Query) async throws -> [Post] {
        let (posts, favorites) = try await (query.getDocuments(as: Post.self), fetchFavorites())
        return posts.map { post in
            post.setting(\.isFavorite, to: favorites.contains(post.id))
        }
    }
    
    // returns the posts in favorite that matches the current user id.
    func fetchFavorites() async throws -> [Post.ID] {
        return try await favoritesReference
            .whereField("userID", isEqualTo: user.id)
            .getDocuments(as: Favorite.self)
            .map(\.postID)
    }
    
    struct Favorite: Identifiable, Codable {
        var id: String {
            postID.uuidString + "-" + userID
        }
        let postID: Post.ID
        let userID: User.ID
    }
}

private extension Post {
    func setting<T>(_ property: WritableKeyPath<Post, T>, to newValue: T) -> Post {
        var post = self
        post[keyPath: property] = newValue
        return post
    }
}



#if DEBUG
struct PostsRepositoryStub: PostsRepositoryProtocol {
    let state: Loadable<[Post]>
    
    func create(_ post: Post) async throws {}
    func fetchAllPosts() async throws -> [Post] {
        return try await state.simulate()
    }
    func delete(_ post: Post) async throws {}
    func favoriteAction(_ post: Post) async throws {}
    func fetchFavoritePosts() async throws -> [Post] {
        return try await state.simulate()
    }
    var user = User.testUser
    func fetchPosts(by author: User) async throws -> [Post] {
        return try await state.simulate()
    }
}
#endif
