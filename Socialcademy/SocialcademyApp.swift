//
//  SocialcademyApp.swift
//  Socialcademy
//
//  Created by Joel Alejandro Milla Lopez on 05/01/24.
//

import SwiftUI
import Firebase

@main
struct SocialacademyApp: App {
    init () {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            AuthView()
        }
    }
}
