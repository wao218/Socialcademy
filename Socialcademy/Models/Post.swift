//
//  Post.swift
//  Socialcademy
//
//  Created by wesley osborne on 11/1/23.
//

import Foundation

struct Post: Identifiable, Codable {
    var title: String
    var content: String
    var authorName: String
    var timestamp = Date()
    var id = UUID()
    
    func contains(_ string: String) -> Bool {
        let properties = [title, content, authorName].map { $0.lowercased() }
        let query = string.lowercased()
        let matches = properties.filter { $0.contains(query) }
        return !matches.isEmpty
    }
}

extension Post {
    static let testPost = Post(title: "Lorem ipsum", content: "Lorem ipsum dolar sit amet, consectetur adipiscing elit, sed do eiusmod tmpor incideidunt ut labore et dolre magna aliquia.", authorName: "Jamie Harris")
}
