//
//  PostsViewModel.swift
//  Socialcademy
//
//  Created by wesley osborne on 11/2/23.
//

import Foundation

@MainActor
class PostsViewModel: ObservableObject {
    @Published var posts = [Post]()
    
    func makeCreateAction() -> NewPostForm.CreateAction {
        return { [weak self] post in
            try await PostsRepository.create(post)
            self?.posts.insert(post, at: 0)
        }
    }
    
    func fetchPosts() {
        Task {
            do {
                posts = try await PostsRepository.fetchPosts()
            } catch {
                print("[PostsViewModel] Cannot fetch posts: \(error)")
            }
        }
    }
}
