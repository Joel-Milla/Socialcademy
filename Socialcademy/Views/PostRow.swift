//
//  PostRow.swift
//  Socialcademy
//
//  Created by Joel Alejandro Milla Lopez on 05/01/24.
//

import SwiftUI

struct PostRow: View {
    @ObservedObject var postRowViewModel: PostRowViewModel
    @State private var showConfirmationDialog = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10, content: {
            HStack {
                Text(postRowViewModel.author.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Spacer()
                Text(postRowViewModel.timestamp.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
            }
            .foregroundStyle(.gray)
            Text(postRowViewModel.title)
                .font(.title3)
                .fontWeight(.semibold)
            Text(postRowViewModel.content)
            HStack {
                FavoriteButton(isFavorite: postRowViewModel.isFavorite, action: {postRowViewModel.favoritePost()})

                Spacer()

                if postRowViewModel.canDeletePost {
                    Button(role: .destructive, action: {
                        showConfirmationDialog = true
                    }) {
                            Label("Delete", systemImage: "trash")
                    }
                }
            }
            .labelStyle(.iconOnly)
            .buttonStyle(.borderless)
        })
        .padding(.vertical)
        .confirmationDialog("Are you sure you want to delete this post?", isPresented: $showConfirmationDialog, titleVisibility: .visible) {
            Button(role: .destructive, action: {postRowViewModel.deletePost()}) {
                Text("Delete")
            }
        }
        .alert("Error", error: $postRowViewModel.error)
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
        PostRow(postRowViewModel: PostRowViewModel(post: Post.testPost, deleteAction: {}, favoriteAction: {}))
    }
}
