//
//  CommentsViewModel.swift
//  Socialcademy
//
//  Created by Joel Alejandro Milla Lopez on 08/01/24.
//

import Foundation

@MainActor
class CommentsViewModel: ObservableObject {
    @Published var comments: Loadable<[Comment]> = .loading
    
    private let commentsRepository: CommentsRepositoryProtocol
    
    init(commentsRepository: CommentsRepositoryProtocol) {
        self.commentsRepository = commentsRepository
    }
    
    func fetchComments() {
        Task {
            do {
                self.comments = .loaded(try await commentsRepository.fetchComments())
            } catch {
                print("[CommentsViewModel] Error while fetching comments: \(error)")
                comments = .error(error)
            }
        }
    }
    
    func makeNewCommentViewModel() -> FormViewModel<Comment> {
        return FormViewModel<Comment>(initialValue: Comment(content: "", author: commentsRepository.user)) {
            [weak self] comment in
            try await self?.commentsRepository.create(comment)
            self?.comments.value?.insert(comment, at: 0)
        }
    }
}
