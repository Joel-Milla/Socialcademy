//
//  NewPostForm.swift
//  Socialcademy
//
//  Created by Joel Alejandro Milla Lopez on 05/01/24.
//

import SwiftUI

struct NewPostForm: View {
    @StateObject var newPostViewModel: FormViewModel<Post>
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Title", text: $newPostViewModel.title)
                }
                Section("Content") {
                    TextEditor(text: $newPostViewModel.content)
                        .multilineTextAlignment(.leading)
                }
                
                Button(action: newPostViewModel.submit, label: {
                    if newPostViewModel.isWorking {
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
            .onSubmit(newPostViewModel.submit)
            .navigationTitle("New Post")
        }
        .disabled(newPostViewModel.isWorking)
        .alert("Cannot Create Post", error: $newPostViewModel.error)
        .onChange(of: newPostViewModel.isWorking) { isWorking in
            guard !isWorking, newPostViewModel.error == nil else { return }
            dismiss()
        }
    }
}

#Preview {
    NewPostForm(newPostViewModel: FormViewModel(initialValue: Post.testPost, action: {_ in}))
}
