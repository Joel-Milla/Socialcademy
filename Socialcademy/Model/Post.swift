//
//  Post.swift
//  Socialcademy
//
//  Created by Joel Alejandro Milla Lopez on 05/01/24.
//

import Foundation

struct Post: Identifiable {
    var title: String
    var content: String
    var authorName: String
    var timestamp = Date()
    var id = UUID()
}
