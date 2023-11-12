//
//  PostsViewModel.swift
//  Socialcademy
//
//  Created by wesley osborne on 11/2/23.
//

import Foundation

@MainActor
class PostsViewModel: ObservableObject {
    enum Filter {
        case all, favorites
    }
    
    @Published var posts: Loadable<[Post]> = .loading
    
    private let postsRepository: PostsRepositoryProtocol
    private let filter: Filter
    
    var title: String {
        switch filter {
        case .all:
            return "Posts"
        case .favorites:
            return "Favorites"
        }
    }
    
    init(filter: Filter = .all, postsRepository: PostsRepositoryProtocol) {
        self.filter = filter
        self.postsRepository = postsRepository
    }
    
    func fetchAllPosts() {
        Task {
            do {
                posts = .loaded(try await postsRepository.fetchPosts(matching: filter))
            } catch {
                print("[PostsViewModel] Cannot fetch posts: \(error)")
                posts = .error(error)
            }
        }
    }
    
    func makePostRowViewModel(for post: Post) -> PostRowViewModel {
        return PostRowViewModel(
            post: post,
            deleteAction: { [weak self] in
                try await self?.postsRepository.delete(post)
                self?.posts.value?.removeAll { $0.id == post.id }
            },
            favoriteAction: { [weak self] in
                let newValue = !post.isFavorite
                try await newValue ? self?.postsRepository.favorite(post) : self?.postsRepository.unfavorite(post)
                guard let index = self?.posts.value?.firstIndex(of: post) else { return }
                self?.posts.value?[index].isFavorite = newValue

            }
        )
    }
    
    func makeNewPostViewModel() -> FormViewModel<Post> {
        return FormViewModel(initialValue: Post(title: "", content: "", author: postsRepository.user)) { [weak self] post in
            try await self?.postsRepository.create(post)
            self?.posts.value?.insert(post, at: 0)
        }
    }
}

private extension PostsRepositoryProtocol {
    func fetchPosts(matching filter: PostsViewModel.Filter) async throws -> [Post] {
        switch filter {
        case .all:
            return try await fetchAllPosts()
        case .favorites:
            return try await fetchFavoritePosts()
        }
    }
}
