//
//  PostsList.swift
//  Socialcademy
//
//  Created by Joel Alejandro Milla Lopez on 05/01/24.
//

import SwiftUI

struct PostsList: View {
    private var posts: [Post] = [Post.testPost]
    @State private var searchText = ""
    @State private var showNewPostForm = false
    
    var body: some View {
        NavigationStack {
            List(posts) { post in
                
                if searchText.isEmpty || post.contains(searchText) {
                    PostRow(post: post)
                }
            }
            .searchable(text: $searchText)
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
                NewPostForm(createAction: {_ in })
            })
            .navigationTitle("Posts")
        }
    }
}

#Preview {
    PostsList()
}
