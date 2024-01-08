//
//  CommentsList.swift
//  Socialcademy
//
//  Created by Joel Alejandro Milla Lopez on 08/01/24.
//

import SwiftUI

struct CommentsList: View {
    @StateObject var commentsViewModel: CommentsViewModel

    var body: some View {
        Group {
            switch commentsViewModel.comments {
            case .loading:
                ProgressView()
                    .onAppear {
                        commentsViewModel.fetchComments()
                    }
            case let .error(error):
                EmptyListView(title: "Cannot Load Comments",
                              message: error.localizedDescription) {
                    commentsViewModel.fetchComments()
                }
            case .empty:
                EmptyListView(title: "No comments", message: "Be the first to leave a comment.")
            case let .loaded(comments):
                List(comments) { comment in
                    Text(comment.content)
                }
                .animation(.default, value: comments)
            }
        }
        .navigationTitle("Comments")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    CommentsList(commentsViewModel: CommentsViewModel(commentsRepository: CommentsRepositoryStub(state: .loaded([Comment.testComment]))))
}
