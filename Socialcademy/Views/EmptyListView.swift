//
//  EmptyListView.swift
//  Socialcademy
//
//  Created by Joel Alejandro Milla Lopez on 05/01/24.
//

import SwiftUI

struct EmptyListView: View {
    let title: String
    let message: String
    var retryAction: (() -> Void)?
    var body: some View {
        VStack (alignment: .center, spacing: 10, content: {
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
            Text(message)
            if let retryAction = retryAction {
                Button(action: {
                    retryAction()
                }, label: {
                    Text("Try Again")
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 5).stroke(Color.secondary))
                })
                .padding(.top)
            }
        })
        .font(.subheadline)
        .multilineTextAlignment(.center)
        .foregroundStyle(.secondary)
        .padding()
    }
}

#Preview {
    EmptyListView(
        title: "Cannot Load Posts",
        message: "Something went wrong while loading posts. Please check your Internet connection.",
        retryAction: {}
    )
}

#Preview {
    EmptyListView(
        title: "No Posts",
        message: "There aren’t any posts yet."
    )
}
