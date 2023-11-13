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
            case let .loaded(comments):
                List(comments) { comment in
                    CommentRow(comment: comment)
                }
                .animation(.default, value: comments)
            }
        }
        .navigationTitle("Comments")
        .navigationBarTitleDisplayMode(.inline)
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
