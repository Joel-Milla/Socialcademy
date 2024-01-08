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
}
