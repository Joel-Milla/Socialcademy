//
//  Post.swift
//  Socialcademy
//
//  Created by Joel Alejandro Milla Lopez on 05/01/24.
//

import Foundation

struct Post: Identifiable, Equatable {
    var title: String
    var content: String
    var author: User
    var isFavorite: Bool = false
    var timestamp = Date()
    var id = UUID()
    
    func contains(_ text: String) -> Bool {
        let properties = [title, content, author.name].map {$0.lowercased()}
        let query = text.lowercased()
        
        let matches = properties.filter {$0.contains(query)}
        return !matches.isEmpty
    }
}

extension Post: Codable {
    enum CodingKeys: CodingKey {
        case title, content, author, timestamp, id
    }
}

extension Post {
    static let testPost = Post(
        title: "Lorem ipsum",
        content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
        author: User.testUser
    )
}
