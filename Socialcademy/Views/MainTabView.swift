//
//  MainTabView.swift
//  Socialcademy
//
//  Created by Joel Alejandro Milla Lopez on 06/01/24.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject private var factory: ViewModelFactory
    
    var body: some View {
        TabView {
            NavigationStack {
                PostsList(postViewModel: factory.makePostsViewModel())
            }
                .tabItem {
                    Label("Posts", systemImage: "list.dash")
                }
            NavigationStack {
                PostsList(postViewModel: factory.makePostsViewModel(filter: .favorites))
            }
                .tabItem {
                    Label("Favorites", systemImage: "heart")
                }
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
        }
    }
}

#Preview {
    MainTabView()
}
