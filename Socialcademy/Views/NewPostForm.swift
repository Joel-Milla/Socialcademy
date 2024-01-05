//
//  NewPostForm.swift
//  Socialcademy
//
//  Created by Joel Alejandro Milla Lopez on 05/01/24.
//

import SwiftUI

struct NewPostForm: View {
    typealias CreateAction = (Post) async throws -> Void
    let createAction: CreateAction
    
    @State private var post = Post(title: "", content: "", authorName: "")
    
    @State private var state: FormState = .idle
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
                    if state == .working {
                        ProgressView()
                    } else {
                        Text("Create Post")
                    }
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
        .disabled(state == .working)
        .alert("Cannot Create Post", isPresented: $state.isError, actions: {}) {
            Text("Sorry, something went wrong.")
        }
    }
    
    private func createPost() {
        state = .working
        Task {
            do {
                try await createAction(post)
                dismiss()
            } catch {
                print("[NewPostFrom] Error while creating a post: \(error)")
                state = .error
            }
        }
    }
}

private extension NewPostForm {
    // Form state of request
    enum FormState {
        case idle, working, error
        
        var isError: Bool {
            get {
                self == .error
            }
            set {
                guard !newValue else {return}
                self = .idle
            }
        }
    }
}

#Preview {
    NewPostForm(createAction: {_ in })
}
