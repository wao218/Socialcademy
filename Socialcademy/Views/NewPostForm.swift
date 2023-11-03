//
//  NewPostForm.swift
//  Socialcademy
//
//  Created by wesley osborne on 11/2/23.
//

import SwiftUI

struct NewPostForm: View {
    typealias CreateAction = (Post) async throws -> Void
    
    let createAction: CreateAction
    
    @State private var post = Post(title: "", content: "", authorName: "")
    
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
                Button(action: createPost) {
                    Text("Create Post")
                }
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
                dismiss()
            } catch {
                print("[NewPostForm] Cannot create post: \(error)")
            }
        }
    }
}

#Preview {
    NewPostForm(createAction: { _ in })
}
