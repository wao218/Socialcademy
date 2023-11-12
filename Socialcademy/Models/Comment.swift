//
//  Comment.swift
//  Socialcademy
//
//  Created by wesley osborne on 11/12/23.
//

import Foundation

struct Comment: Identifiable, Equatable, Codable {
    var content: String
    var author: User
    var timestamp = Date()
    var id = UUID()
}

extension Comment {
    static let testComment = Comment(content: "Lorem ipsum dolar set amet.", author: User.testUser)
}
