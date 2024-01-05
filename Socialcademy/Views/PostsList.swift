//
//  PostsList.swift
//  Socialcademy
//
//  Created by Joel Alejandro Milla Lopez on 05/01/24.
//

import SwiftUI

struct PostsList: View {
    @StateObject var postViewModel = PostsViewModel()
    @State private var searchText = ""
    @State private var showNewPostForm = false
    
    var body: some View {
        NavigationStack {
            Group {
                switch postViewModel.posts {
                case .loading:
                    ProgressView()
                case let .error(error):
                    EmptyListView(
                        title: "Cannot Load Posts",
                        message: error.localizedDescription,
                        retryAction: {
                            postViewModel.fetchPosts()
                        }
                    )
                case .empty:
                    EmptyListView(
                        title: "No Posts",
                        message: "There aren’t any posts yet."
                    )
                case let .loaded(posts):
                    List(posts) { post in
                        if searchText.isEmpty || post.contains(searchText) {
                            PostRow(post: post)
                        }
                    }
                    .searchable(text: $searchText)
                }
            }
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showNewPostForm = true
                    }, label: {
                        Label("New Post", systemImage: "square.and.pencil")
                    })
                }
            })
            .sheet(isPresented: $showNewPostForm, content: {
                NewPostForm(createAction: postViewModel.makeCreateAction())
            })
            .navigationTitle("Posts")
        }
        .onAppear(perform: {
            postViewModel.fetchPosts()
        })
    }
}

#Preview {
    PostsList()
}
