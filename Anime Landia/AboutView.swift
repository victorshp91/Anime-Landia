//
//  AboutView.swift
//  Anime Landia
//
//  Created by Victor Saint Hilaire on 10/7/23.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
                Text("About AnimeTracker Pro")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Image("logo")
                    
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(radius: 5)
                    
              
                    Text("Welcome to AnimeTracker Pro! Your ultimate source for information about the exciting world of anime and its characters. This app has been created by and for anime enthusiasts.")
                        .font(.body)
                    
                    FeatureView(iconName: "safari", title: "Explore", description: "Explore an extensive database of anime and characters. Find detailed information about your favorite series and characters.")
                    
                    FeatureView(iconName: "scroll", title: "Discover", description: "Dive into the thrilling world of anime. Access details of each character and discover new series to watch.")
                    
                    FeatureView(iconName: "star", title: "Favorites", description: "Mark your favorite animes and characters for quick access in the future.")
                    
                    
                    FeatureView(iconName: "magnifyingglass", title: "Search", description: "Quickly find animes and characters by name. Explore our extensive database to discover new anime gems.")
                    
                    FeatureView(iconName: "checkmark.circle", title: "Track Your Progress", description: "Keep track of the animes you're watching, have completed, or plan to watch in the future.")
                    
                    
                    FeatureView(iconName: "newspaper", title: "Why AnimeTracker Pro?", description: "AnimeTracker Pro is dedicated to providing a comprehensive experience for anime fans. Our mission is to help you discover, enjoy, and share your passion for anime.")
                
            }
            .padding()
        }
        .background(Color.gray.opacity(0.1))
        .navigationBarTitle("About", displayMode: .inline)
    }
    
    struct FeatureView: View {
        let iconName: String
        let title: String
        let description: String
        
        var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                Image(systemName: iconName)
                    .font(.title)
                    
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(title)
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(description)
                    .font(.body)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
                .padding()
                .background(.white) // Replace with your background color
                .foregroundStyle(.black)
            .cornerRadius(10)
            
        }
    }
}

#Preview {
    AboutView()
}
