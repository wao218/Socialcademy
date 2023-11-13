//
//  CommentsList.swift
//  Socialcademy
//
//  Created by wesley osborne on 11/12/23.
//

import SwiftUI

struct CommentsList: View {
    @StateObject var viewModel: CommentsViewModel
    
    var body: some View {
        Group {
            switch viewModel.comments {
            case .loading:
                ProgressView()
                    .onAppear {
                        viewModel.fetchComments()
                    }
            case let .error(error):
                EmptyListView(
                    title: "Cannot Load Comments",
                    message: error.localizedDescription,
                    retryAction: {
                        viewModel.fetchComments()
                    }
                )
            case .empty:
                EmptyListView(title: "No Comments", message: "Be the first to leave a comment.")
            case let .loaded(comments):
                List(comments) { comment in
                    CommentRow(viewModel: viewModel.makeCommentRowViewModel(for: comment))
                }
                
                .animation(.default, value: comments)
                
            }
        }
        .navigationTitle("Comments")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                NewCommentForm(viewModel: viewModel.makeNewCommentViewModel())
            }
        }
    }
}

private extension CommentsList {
    struct NewCommentForm: View {
        @StateObject var viewModel: FormViewModel<Comment>
        
        var body: some View {
            HStack {
                TextField("Comment", text: $viewModel.content)
                Button(action: viewModel.submit, label: {
                    if viewModel.isWorking {
                        ProgressView()
                    } else {
                        Text("Send")
                    }
                })
            }
            .alert("Cannot Post Comment", error: $viewModel.error)
            .animation(.default, value: viewModel.isWorking)
            .disabled(viewModel.isWorking)
            .onSubmit(viewModel.submit)
        }
    }
}

#if DEBUG
@MainActor
private struct ListPreview: View {
    let state: Loadable<[Comment]>
    
    var body: some View {
        let commentsRepository = CommentsRepositoryStub(state: state)
        let viewModel = CommentsViewModel(commentsRepository: commentsRepository)
        NavigationStack {
            CommentsList(viewModel: viewModel)
        }
    }
}

#Preview("Loaded State") {
    ListPreview(state: .loaded([Comment.testComment]))
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
