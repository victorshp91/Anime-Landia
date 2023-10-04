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
            NavigationStack{
                HomeView()
                 
            } .tabItem {
                Label("Home", systemImage: "circle.circle.fill")
               
            }
            NavigationStack{
                DiscoverView()
                 
            } .tabItem {
                Label("Discover", systemImage: "binoculars")
                  
            }
            
            NavigationStack{
                SearchView()
                 
            } .tabItem {
                Label("Search", systemImage: "magnifyingglass.circle.fill")
                  
            }
            
            NavigationStack{
                AccountView()
                 
            } .tabItem {
                Label("Account", systemImage: "person.circle.fill")
                  
            }
            
        }.accentColor(.cyan)

    }
}

#Preview {
    TabBarMenu()
}
