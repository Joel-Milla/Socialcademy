//
//  CommentsList.swift
//  Socialcademy
//
//  Created by Joel Alejandro Milla Lopez on 08/01/24.
//

import SwiftUI

struct CommentsList: View {
    @StateObject var commentsViewModel: CommentsViewModel
    
    @State var createNewPost = false
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
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                createNewPost = true
                            } label: {
                                Image(systemName: "paperplane")
                            }
                        }
                    }
            case let .loaded(comments):
                List(comments) { comment in
                    CommentRow(commentRowViewModel: commentsViewModel.makeCommentRowViewModel(for: comment))
                }
                .animation(.default, value: comments)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            createNewPost = true
                        } label: {
                            Image(systemName: "paperplane")
                        }
                    }
                }
            }
        }
        .navigationTitle("Comments")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $createNewPost) {
            NewCommentForm(formViewModel: commentsViewModel.makeNewCommentViewModel())
        }
    }
}

private extension CommentsList {
    struct NewCommentForm: View {
        @StateObject var formViewModel: FormViewModel<Comment>
        @Environment(\.dismiss) private var dismiss
        
        var body: some View {
            Form {
                Section("Content") {
                    TextEditor(text: $formViewModel.content)
                        .multilineTextAlignment(.leading)
                }
                
                Button(action: formViewModel.submit, label: {
                    if formViewModel.isWorking {
                        ProgressView()
                    } else {
                        Text("Create Comment")
                    }
                })
                .font(.headline)
                .frame(maxWidth: .infinity)
                .foregroundStyle(.white)
                .padding()
                .listRowBackground(Color.accentColor)
            }
            .alert("Cannot Post Comment", error: $formViewModel.error)
            .animation(.default, value: formViewModel.isWorking)
            .disabled(formViewModel.isWorking)
            .onSubmit(formViewModel.submit)
            .onChange(of: formViewModel.isWorking) { isWorking in
                guard !isWorking, formViewModel.error == nil else { return }
                dismiss()
            }
        }
    }
}

#Preview {
    NavigationStack {
        CommentsList(commentsViewModel: CommentsViewModel(commentsRepository: CommentsRepositoryStub(state: .loaded([Comment.testComment]))))
    }
}
