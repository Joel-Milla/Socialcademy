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
    
    var body: some View {
        NavigationStack {
            List(posts) { post in
                
                if searchText.isEmpty || post.contains(searchText) {
                    PostRow(post: post)
                }
            }
            .searchable(text: $searchText)
            .navigationTitle("Posts")
        }
    }
}

#Preview {
    PostsList()
}
