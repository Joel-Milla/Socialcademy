//
//  PostsRepository.swift
//  Socialcademy
//
//  Created by Joel Alejandro Milla Lopez on 05/01/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol PostsRepositoryProtocol {
    func create(_ post: Post) async throws
    func fetchAllPosts() async throws -> [Post]
    func delete(_ post: Post) async throws
    func favoriteAction(_ post: Post) async throws
    func fetchFavoritePosts() async throws -> [Post]
}

struct PostsRepository: PostsRepositoryProtocol {
    let postsReference = Firestore.firestore().collection("posts")
    
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
        let document = postsReference.document(post.id.uuidString)
        try await document.delete()
    }
    
    func favoriteAction(_ post: Post) async throws {
        let document = postsReference.document(post.id.uuidString)
        if post.isFavorite {
            try await document.setData(["isFavorite": false], merge: true)
        } else {
            try await document.setData(["isFavorite": true], merge: true)
        }
    }
    
    func fetchFavoritePosts() async throws -> [Post] {
        let query = postsReference
            .order(by: "timestamp", descending: true)
            .whereField("isFavorite", isEqualTo: true)
        return try await fetchPosts(from: query)
    }
    
    private func fetchPosts(from query: Query) async throws -> [Post] {
        let snapshot = try await query.getDocuments()
        let posts = snapshot.documents.compactMap { document in
            try! document.data(as: Post.self)
        }
        return posts
    }
}


private extension DocumentReference {
    func setData<T: Encodable>(from value: T) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            // Method only throws if there’s an encoding error, which indicates a problem with our model.
            // We handled this with a force try, while all other errors are passed to the completion handler.
            try! setData(from: value) { error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                continuation.resume()
            }
        }
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
}
#endif
