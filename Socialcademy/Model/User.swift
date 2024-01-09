//
//  User.swift
//  Socialcademy
//
//  Created by Joel Alejandro Milla Lopez on 06/01/24.
//

import Foundation

struct User: Identifiable, Equatable, Codable {
    var id: String
    var name: String
    var imageURL: URL?
}

extension User {
    static let testUser = User(id: "", name: "Joel Milla", imageURL: URL(string: "https://source.unsplash.com/lw9LrnpUmWw/480x480"))
}
