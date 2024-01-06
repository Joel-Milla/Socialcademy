//
//  PostRow.swift
//  Socialcademy
//
//  Created by Joel Alejandro Milla Lopez on 05/01/24.
//

import SwiftUI

struct PostRow: View {
    typealias DeleteAction = () async throws -> Void

    let post: Post
    var deleteAction: DeleteAction
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10, content: {
            HStack {
                Text(post.authorName)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Spacer()
                Text(post.timestamp.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
            }
            .foregroundStyle(.gray)
            Text(post.title)
                .font(.title3)
                .fontWeight(.semibold)
            Text(post.content)
            HStack {
                Spacer()
                Button(role: .destructive) {
                    deletePost()
                } label: {
                    Label("Delete", systemImage: "trash")
                        .labelStyle(.iconOnly)
                }
            }
        })
        .padding(.vertical)
    }
    
    private func deletePost() {
        Task {
            do {
                try await deleteAction()
            } catch {
                print("[PostRow] Unable to delete post: \(error)")
            }
        }
    }
}

#Preview {
    List {
        PostRow(post: Post.testPost, deleteAction: {})
    }
}
