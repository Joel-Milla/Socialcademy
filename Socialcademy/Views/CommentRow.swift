//
//  CommentRow.swift
//  Socialcademy
//
//  Created by Joel Alejandro Milla Lopez on 08/01/24.
//

import SwiftUI

struct CommentRow: View {
    @ObservedObject var commentRowViewModel: CommentRowViewModel
    @State private var showConfirmationDialog = false

    var body: some View {
        VStack (alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                Text(commentRowViewModel.author.name)
                    .font(.subheadline)
                Spacer()
                Text(commentRowViewModel.timestamp.formatted())
                    .foregroundStyle(.gray)
                    .font(.caption)
            }
            Text(commentRowViewModel.content)
                .font(.headline)
                .fontWeight(.regular)
        }
        .padding(5)
        .swipeActions {
            if commentRowViewModel.canDeleteComment {
                Button(role: .destructive) {
                    showConfirmationDialog = true
                } label: {
                    Label("Delete comment", systemImage: "trash")
                }
            }
        }
        .confirmationDialog("Are you sure you want to delete this comment?", isPresented: $showConfirmationDialog, titleVisibility: .visible) {
            Button("Delete", role: .destructive) {
                commentRowViewModel.deleteComment()
            }
        }
    }
}

#Preview {
    CommentRow(commentRowViewModel: CommentRowViewModel(comment: Comment(content: "", author: User.testUser), deleteAction: {}))
}
