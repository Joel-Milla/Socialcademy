//
//  CommentRowViewModel.swift
//  Socialcademy
//
//  Created by Joel Alejandro Milla Lopez on 08/01/24.
//

import Foundation

@MainActor
@dynamicMemberLookup
class CommentRowViewModel: ObservableObject {
    typealias Action = () async throws -> Void

    @Published var comment: Comment
    
    subscript<T>(dynamicMember keyPath: KeyPath<Comment,T>) -> T {
        comment[keyPath: keyPath]
    }
    
    init(comment: Comment) {
        self.comment = comment
    }
}
