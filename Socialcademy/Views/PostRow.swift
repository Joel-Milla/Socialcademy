//
//  PostRow.swift
//  Socialcademy
//
//  Created by Joel Alejandro Milla Lopez on 05/01/24.
//

import SwiftUI

struct PostRow: View {
    typealias Action = () async throws -> Void
    
    let post: Post
    var deleteAction: Action
    var toggleFavoriteButtonAction: Action
    @State private var showConfirmationDialog = false
    @State private var error: Error?
    
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
                FavoriteButton(isFavorite: post.isFavorite, action: favoriteAction)

                Spacer()

                Button(role: .destructive, action: {
                    showConfirmationDialog = true
                }) {
                    Label("Delete", systemImage: "trash")
                }
            }
            .labelStyle(.iconOnly)
            .buttonStyle(.borderless)
        })
        .padding(.vertical)
        .confirmationDialog("Are you sure you want to delete this post?", isPresented: $showConfirmationDialog, titleVisibility: .visible) {
            Button(role: .destructive, action: deletePost) {
                Text("Delete")
            }
        }
        .alert("Cannot Delete Post", error: $error)
        
    }
    
    private func deletePost() {
        Task {
            do {
                try await deleteAction()
            } catch {
                print("[PostRow] Unable to delete post: \(error)")
                self.error = error
            }
        }
    }
    
    private func favoriteAction() {
        Task {
            do {
                try await toggleFavoriteButtonAction()
            } catch {
                print("[PostRow] Unable to update post of favorite: \(error)")
                self.error = error
            }
        }
    }
}

// Button to remove/add a post from/to favorites.
private extension PostRow {
    struct FavoriteButton: View {
        let isFavorite: Bool
        let action: () -> Void
    
        var body: some View {
            Button(action: {
                action()
            }, label: {
                if isFavorite {
                    Label("Remove from favorites", systemImage: "heart.fill")
                } else {
                    Label("Add to favorites", systemImage: "heart")
                }
            })
            .foregroundStyle(isFavorite ? .red : .gray)
        }
    }
}

#Preview {
    List {
        PostRow(post: Post.testPost[0], deleteAction: {}, toggleFavoriteButtonAction: {})
    }
}
