//
//  CommentsRepository.swift
//  Socialcademy
//
//  Created by Joel Alejandro Milla Lopez on 08/01/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol CommentsRepositoryProtocol {
    var user: User { get }
    var post: Post { get }
    func fetchComments() async throws -> [Comment]
    mutating func create (_ comment: Comment) async throws
    mutating func delete(_ comment: Comment) async throws
}

extension CommentsRepositoryProtocol {
    func canDelete(_ comment: Comment) -> Bool {
        [comment.author.id, post.author.id].contains(user.id)
    }
}

struct CommentsRepository: CommentsRepositoryProtocol {
    var user: User
    var post: Post
    
    private var commentsReference: CollectionReference {
        let postsReference = Firestore.firestore().collection("posts")
        let document = postsReference.document(post.id.uuidString)
        return document.collection("comments")
    }
    private var postReference: (DocumentReference, Int) {
        let postsReference = Firestore.firestore().collection("posts")
        return (postsReference.document(post.id.uuidString), post.numberOfComments)
    }
    
    func fetchComments() async throws -> [Comment] {
        let comments = try await commentsReference
            .order(by: "timestamp", descending: true)
            .getDocuments(as: Comment.self)
        return comments
    }
    
    mutating func create(_ comment: Comment) async throws {
        let document = commentsReference.document(comment.id.uuidString)
        try await document.setData(from: comment)
        let (postReference, _) = postReference
        self.post.numberOfComments += 1
        try await postReference.setData(["numberOfComments":(post.numberOfComments)], merge: true)
    }
    
    mutating func delete(_ comment: Comment) async throws {
        precondition(canDelete(comment))
        let document = commentsReference.document(comment.id.uuidString)
        try await document.delete()
        let (postReference, _) = postReference
        self.post.numberOfComments -= 1
        try await postReference.setData(["numberOfComments":(post.numberOfComments)], merge: true)
    }
}


#if DEBUG
struct CommentsRepositoryStub: CommentsRepositoryProtocol {
    let user = User.testUser
    let post = Post.testPost
    let state: Loadable<[Comment]>
    
    func fetchComments() async throws -> [Comment] {
        return try await state.simulate()
    }
    
    mutating func create(_ comment: Comment) async throws {}
    mutating func delete(_ comment: Comment) async throws {}
}
#endif
