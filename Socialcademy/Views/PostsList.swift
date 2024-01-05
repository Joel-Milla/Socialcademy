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
        List(posts) { post in
            Text(post.title)
        }
    }
}

#Preview {
    PostsList()
}
