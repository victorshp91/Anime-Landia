//
//  DiscoverView.swift
//  Anime Landia
//
//  Created by Victor Saint Hilaire on 9/30/23.
//

import SwiftUI

struct DiscoverView: View {
    
    // PARA MANEJAR EL COLOR DEL DARK MODE
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(alignment: .leading){
                topAnimeView(showing: .airing)
                    .frame(height: 300)
                topAnimeView(showing: .upcoming)
                    .frame(height: 300)
                TopCharactersView()
                    .frame(height: 300)
                
                    .navigationTitle("Discover")
                Spacer()
            }.padding(.top)
        }
            .background(Color("background"))
            .foregroundStyle(.white)
    }
}

#Preview {
    DiscoverView()
}
