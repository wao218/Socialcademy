//
//  User.swift
//  Socialcademy
//
//  Created by wesley osborne on 11/10/23.
//

import Foundation

struct User: Identifiable, Equatable, Codable {
    var id: String
    var name: String
}

extension User {
    static let testUser = User(id: "", name: "Jamie Harris")
}
