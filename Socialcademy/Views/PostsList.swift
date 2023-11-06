//
//  PostsList.swift
//  Socialcademy
//
//  Created by wesley osborne on 11/1/23.
//

import SwiftUI

struct PostsList: View {
    @StateObject var viewModel = PostsViewModel()
    
    @State private var searchText = ""
    @State private var showNewPostForm = false
    
    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.posts {
                case .loading:
                    ProgressView()
                case let .error(error):
                    EmptyListView(title: "Cannot Load Posts", message: error.localizedDescription) {
                        viewModel.fetchAllPosts()
                    }
                case .empty:
                    EmptyListView(title: "No Posts", message: "There aren't any posts yet.")
                case let .loaded(posts):
                    List(posts) { post in
                        if searchText.isEmpty || post.contains(searchText) {
                            PostRow(viewModel: viewModel.makePostRowViewModel(for: post))
                        }
                    }
                    .searchable(text: $searchText)
                    .animation(.default, value: posts)
                }
            }
            .navigationTitle(viewModel.title)
            .toolbar {
                Button {
                    showNewPostForm = true
                } label: {
                    Label("New Post", systemImage: "square.and.pencil")
                }
            }
        }
        .sheet(isPresented: $showNewPostForm, content: {
            NewPostForm(createAction: viewModel.makeCreateAction())
        })
        .onAppear {
            viewModel.fetchAllPosts()
        }
    }
}

#if DEBUG
@MainActor
private struct ListPreview: View {
    let state: Loadable<[Post]>
    
    var body: some View {
        let postsRepository = PostsRepositoryStub(state: state)
        let viewModel = PostsViewModel(postsRepository: postsRepository)
        PostsList(viewModel: viewModel)
    }
}

#Preview("Loaded State") {
    ListPreview(state: .loaded([Post.testPost]))
}

#Preview("Empty State") {
    ListPreview(state: .empty)
}

#Preview("Error State") {
    ListPreview(state: .error)
}

#Preview("Loading State") {
    ListPreview(state: .loading)
}

#endif
