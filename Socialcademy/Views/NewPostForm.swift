//
//  NewPostForm.swift
//  Socialcademy
//
//  Created by Joel Alejandro Milla Lopez on 05/01/24.
//

import SwiftUI

struct NewPostForm: View {
    typealias CreateAction = (Post) async throws -> Void
    
    @State private var post = Post(title: "", content: "", authorName: "")

    let createAction: CreateAction
    
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Title", text: $post.title)
                    TextField("Author Name", text: $post.authorName)
                }
                Section("Content") {
                    TextEditor(text: $post.content)
                        .multilineTextAlignment(.leading)
                }
                
                Button(action: createPost, label: {
                    Text("Create Post")
                })
                .font(.headline)
                .frame(maxWidth: .infinity)
                .foregroundStyle(.white)
                .padding()
                .listRowBackground(Color.accentColor)
            }
            .onSubmit(createPost)
            .navigationTitle("New Post")
        }
    }
    
    private func createPost() {
        Task {
            do {
                try await createAction(post)
            } catch {
                print("Error while creating a post: \(error)")
            }
        }
        dismiss()
    }
}

#Preview {
    NewPostForm(createAction: {_ in })
}
