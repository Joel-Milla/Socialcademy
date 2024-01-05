//
//  PostsList.swift
//  Socialcademy
//
//  Created by Joel Alejandro Milla Lopez on 05/01/24.
//

import SwiftUI

struct PostsList: View {
    private var posts: [Post] = [Post.testPost]
    var body: some View {
        NavigationStack {
            List(posts) { post in
                PostRow(post: post)
            }
            .navigationTitle("Posts")
        }
    }
}

#Preview {
    PostsList()
}
