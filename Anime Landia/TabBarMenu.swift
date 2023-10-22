//
//  TabBarMenu.swift
//  Anime Landia
//
//  Created by Victor Saint Hilaire on 9/30/23.
//

import SwiftUI

struct TabBarMenu: View {
    var body: some View {
        TabView {
            Group {
                NavigationStack{
                    Feed()
                        .navigationTitle("Reviews Feed")
                        
                        .toolbarBackground(
                         Color("barColor"),
                         for: .navigationBar)
                        .toolbarColorScheme(.dark, for: .navigationBar)
                        .toolbarBackground(.visible, for: .navigationBar)
                }
                
                .tabItem {
                    Label("Feed", systemImage: "newspaper.fill")
                }
                   
                NavigationStack{
                    RandomView()
                        .background(Color("background"))
                        .toolbarBackground(
                         Color("barColor"),
                         for: .navigationBar)
                        .toolbarColorScheme(.dark, for: .navigationBar)
                        .toolbarBackground(.visible, for: .navigationBar)
                }
                 .tabItem {
                    Label("Random", systemImage: "shuffle.circle.fill")
                    
                }
                NavigationStack {
                    DiscoverView()
            
                        .toolbarBackground(
                         Color("barColor"),
                         for: .navigationBar)
                        .toolbarColorScheme(.dark, for: .navigationBar)
                        .toolbarBackground(.visible, for: .navigationBar)
                    
                }
                 .tabItem {
                    Label("Discover", systemImage: "binoculars")
                    
                }
            
                NavigationStack {
                    TopTenView()
                        .navigationTitle("Top")
                        .toolbarBackground(
                            Color("barColor"),
                            for: .navigationBar)
                        .toolbarColorScheme(.dark, for: .navigationBar)
                        .toolbarBackground(.visible, for: .navigationBar)
                }
                    
                 .tabItem {
                    Label("Top", systemImage: "trophy.fill")
                    
                }
                
                NavigationStack{
                    SearchView()
                        .navigationTitle("Search")
                        .toolbarBackground(
                            Color("barColor"),
                            for: .navigationBar)
                        .toolbarColorScheme(.dark, for: .navigationBar)
                        .toolbarBackground(.visible, for: .navigationBar)
                }
                 .tabItem {
                    Label("Search", systemImage: "magnifyingglass.circle.fill")
                    
                }
                
                
    
            }.toolbarBackground(.visible, for: .tabBar)

                .toolbarBackground(
                    Color("barColor"),
                    for: .tabBar)
            
            
        }.accentColor(.white)
           

    }
}

#Preview {
    TabBarMenu()
}
