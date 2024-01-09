//
//  PostRow.swift
//  Socialcademy
//
//  Created by Joel Alejandro Milla Lopez on 05/01/24.
//

import SwiftUI

struct PostRow: View {
    @EnvironmentObject private var factory: ViewModelFactory
    @ObservedObject var postRowViewModel: PostRowViewModel
    @State private var showConfirmationDialog = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10, content: {
            HStack {
                AuthorView(author: postRowViewModel.author)
                Spacer()
                Text(postRowViewModel.timestamp.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
            }
            .foregroundStyle(.gray)
            if let image = postRowViewModel.imageURL {
                PostImage(url: image)
            }
            Text(postRowViewModel.title)
                .font(.title3)
                .fontWeight(.semibold)
            Text(postRowViewModel.content)
            HStack {
                HStack {
                    Text("\(postRowViewModel.numberOfLikes)")
                    FavoriteButton(isFavorite: postRowViewModel.isFavorite, action: {postRowViewModel.favoritePost()})
                }
                
                HStack {
                    Text("\(postRowViewModel.numberOfComments)")
                    NavigationLink {
                        CommentsList(commentsViewModel: factory.makeCommentsViewModel(for: postRowViewModel.post))
                    } label: {
                        Label("Comments", systemImage: "text.bubble")
                            .foregroundStyle(.gray)
                    }
                }
                
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
            
        })
        .padding()
        .confirmationDialog("Are you sure you want to delete this post?", isPresented: $showConfirmationDialog, titleVisibility: .visible) {
            Button(role: .destructive, action: {postRowViewModel.deletePost()}) {
                Text("Delete")
            }
        }
        .alert("Error", error: $postRowViewModel.error)
    }
}

// Extension to show images on post row
private extension PostRow {
    struct PostImage: View {
        let url: URL
        
        var body: some View {
            AsyncImage(url: url) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } placeholder: {
                Color.clear
            }
        }
    }
}

// Extension that shows the name of the author and a link to show all the authors posts.
private extension PostRow {
    struct AuthorView: View {
        let author: User
        @EnvironmentObject private var factory: ViewModelFactory
        
        var body: some View {
            NavigationLink {
                PostsList(postViewModel: factory.makePostsViewModel(filter: .author(author)))
            } label: {
                HStack {
                    ProfileImage(url: author.imageURL)
                        .frame(width: 40, height: 40)
                    Text(author.name)
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
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
    PostRow(postRowViewModel: PostRowViewModel(post: Post.testPost, deleteAction: {}, favoriteAction: {}))
}
