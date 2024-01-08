//
//  CommentRow.swift
//  Socialcademy
//
//  Created by Joel Alejandro Milla Lopez on 08/01/24.
//

import SwiftUI

struct CommentRow: View {
    let comment: Comment

    var body: some View {
        VStack (alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                Text(comment.author.name)
                    .font(.subheadline)
                Spacer()
                Text(comment.timestamp.formatted())
                    .foregroundStyle(.gray)
                    .font(.caption)
            }
            Text(comment.content)
                .font(.headline)
                .fontWeight(.regular)
        }
        .padding(5)
    }
}

#Preview {
    CommentRow(comment: Comment.testComment)
}