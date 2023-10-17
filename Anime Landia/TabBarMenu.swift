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
                    HomeView()
                        
                        .toolbarBackground(
                         Color("barColor"),
                         for: .navigationBar)
                        .toolbarColorScheme(.dark, for: .navigationBar)
                        .toolbarBackground(.visible, for: .navigationBar)
                }
                 .tabItem {
                    Label("Home", systemImage: "circle.circle.fill")
                    
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
                        .navigationTitle("Top 10")
                        .toolbarBackground(
                            Color("barColor"),
                            for: .navigationBar)
                        .toolbarColorScheme(.dark, for: .navigationBar)
                        .toolbarBackground(.visible, for: .navigationBar)
                }
                    
                 .tabItem {
                    Label("Top 10", systemImage: "10.circle.fill")
                    
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
                
                
                
                NavigationStack {
                    AccountView()
                        .navigationTitle("Account")
                        .toolbarBackground(
                            Color("barColor"),
                            for: .navigationBar)
                        .toolbarColorScheme(.dark, for: .navigationBar)
                        .toolbarBackground(.visible, for: .navigationBar)
                }
                 .tabItem {
                    Label("Account", systemImage: "person.circle.fill")
                    
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
