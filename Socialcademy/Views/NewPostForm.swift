//
//  NewPostForm.swift
//  Socialcademy
//
//  Created by wesley osborne on 11/2/23.
//

import SwiftUI

struct NewPostForm: View {
    @StateObject var viewModel: FormViewModel<Post>
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Title", text: $viewModel.title)
                }
                Section("Content") {
                    TextEditor(text: $viewModel.content)
                        .multilineTextAlignment(.leading)
                }
                Button(action: viewModel.submit) {
                    if viewModel.isWorking {
                        ProgressView()
                    } else {
                        Text("Create Post")
                    }
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .foregroundStyle(.white)
                .padding()
                .listRowBackground(Color.accentColor)
            }
            .onSubmit(viewModel.submit)
            .onChange(of: viewModel.isWorking) {
                guard !viewModel.isWorking, viewModel.error == nil else { return }
                dismiss()
            }
            .navigationTitle("New Post")
        }
        .disabled(viewModel.isWorking)
        .alert("Cannot Create Post", error: $viewModel.error)
    }
}


#Preview {
    NewPostForm(viewModel: FormViewModel(initialValue: Post.testPost, action: { _ in }))
}
