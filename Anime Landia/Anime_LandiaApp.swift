//
//  Anime_LandiaApp.swift
//  Anime Landia
//
//  Created by Victor Saint Hilaire on 9/30/23.
//

import SwiftUI

@main
struct Anime_LandiaApp: App {
    @State private var showWelcomeScreen = true
    var body: some Scene {
        WindowGroup {
            NavigationView{
                if showWelcomeScreen {
                                WelcomeScreeView()
                                    .onAppear {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                            withAnimation {
                                                showWelcomeScreen = false
                                            }
                                        }
                                        
                                    }
                            } else {
                                TabBarMenu() // Tu vista principal
                                    
                            }
                
                    
                
            }
            .toolbarColorScheme(.dark, for: .navigationBar)

        }
    }
}
