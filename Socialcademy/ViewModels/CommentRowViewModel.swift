//
//  CommentRowViewModel.swift
//  Socialcademy
//
//  Created by Joel Alejandro Milla Lopez on 08/01/24.
//

import Foundation

@MainActor
@dynamicMemberLookup
class CommentRowViewModel: ObservableObject, StateManager {
    typealias Action = () async throws -> Void
    
    @Published var comment: Comment
    private let deleteAction: Action?
    var canDeleteComment: Bool { deleteAction != nil }
    @Published var error: Error?
    
    subscript<T>(dynamicMember keyPath: KeyPath<Comment,T>) -> T {
        comment[keyPath: keyPath]
    }
    
    init(comment: Comment, deleteAction: Action?) {
        self.comment = comment
        self.deleteAction = deleteAction
    }
    
    func deleteComment() {
        guard let deleteAction = deleteAction else {
            preconditionFailure("Cannot delete comment: no delete action provided")
        }
        withStateManagingTask(perform: deleteAction)
    }
}
