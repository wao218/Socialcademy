//
//  EmptyListView.swift
//  Socialcademy
//
//  Created by wesley osborne on 11/2/23.
//

import SwiftUI

struct EmptyListView: View {
    let title: String
    let message: String
    var retryAction: (() -> Void)?
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
            Text(message)
            if let retryAction = retryAction {
                Button(action: retryAction) {
                    Text("Try Again")
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 5).stroke(Color.secondary))
                }
                .padding(.top)
            }
        }
        .font(.subheadline)
        .multilineTextAlignment(.center)
        .foregroundStyle(.secondary)
        .padding()
    }
}

#Preview("Error State") {
    EmptyListView(
                title: "Cannot Load Posts",
                message: "Something went wrong while loading posts. Please check your Internet connection.",
                retryAction: {}
            )
}

#Preview("Empty State") {
    EmptyListView(
                title: "No Posts",
                message: "There aren’t any posts yet."
            )
}
