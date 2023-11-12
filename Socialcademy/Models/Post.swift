//
//  Post.swift
//  Socialcademy
//
//  Created by wesley osborne on 11/1/23.
//

import Foundation

struct Post: Identifiable, Equatable {
    var id = UUID()
    var title: String
    var content: String
    var author: User
    var timestamp = Date()
    var isFavorite = false
    
    func contains(_ string: String) -> Bool {
        let properties = [title, content, author.name].map { $0.lowercased() }
        let query = string.lowercased()
        let matches = properties.filter { $0.contains(query) }
        return !matches.isEmpty
    }
}

extension Post: Codable {
    enum CodingKeys: CodingKey {
        case title, content, author, timestamp, id
    }
}

extension Post {
    static let testPost = Post(title: "Lorem ipsum", 
                               content: "Lorem ipsum dolar sit amet, consectetur adipiscing elit, sed do eiusmod tmpor incideidunt ut labore et dolre magna aliquia.",
                               author: User.testUser)
}
