//
//  PostRow.swift
//  Socialcademy
//
//  Created by wesley osborne on 11/1/23.
//

import SwiftUI

struct PostRow: View {
    typealias DeleteAction = () async throws -> Void
    
    let post: Post
    let deleteAction: DeleteAction
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(post.authorName)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Spacer()
                Text(post.timestamp.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
            }
            .foregroundStyle(.gray)
            Text(post.title)
                .font(.title3)
                .fontWeight(.semibold)
            Text(post.content)
            HStack {
                Spacer()
                Button(role: .destructive, action: deletePost) {
                    Label("Delete", systemImage: "trash")
                }
                .labelStyle(.iconOnly)
            }
        }
        .padding(.vertical)
    }
    
    private func deletePost() {
        Task {
            try! await deleteAction()
        }
    }
}

#Preview {
    List {
        PostRow(post: Post.testPost, deleteAction: {})
    }
}
