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
}

extension User {
    static let testUser = User(id: "", name: "Joel Milla")
}
