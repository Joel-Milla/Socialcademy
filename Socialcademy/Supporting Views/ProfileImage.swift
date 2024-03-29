//
//  ProfileImage.swift
//  Socialcademy
//
//  Created by Joel Alejandro Milla Lopez on 09/01/24.
//

import SwiftUI

struct ProfileImage: View {
    let url: URL?
    
    var body: some View {
        GeometryReader { proxy in
            AsyncImage(url: url) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Color.clear
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.gray.opacity(0.25)))
        }
    }
}
