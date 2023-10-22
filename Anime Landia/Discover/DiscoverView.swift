//
//  DiscoverView.swift
//  Anime Landia
//
//  Created by Victor Saint Hilaire on 9/30/23.
//

import SwiftUI

struct DiscoverView: View {
    
    // PARA MANEJAR EL COLOR DEL DARK MODE
    

    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
              
                    
            VStack(alignment: .leading){
                topAnimeView(showing: .airing)
                    .frame(height: 300)
                topAnimeView(showing: .upcoming)
                    .frame(height: 300)
                TopCharactersView()
                    .frame(height: 300)
                
                    .navigationTitle("Discover")
                Spacer()
            }.padding(.top)
        }.toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                
                
                NavigationLink(destination: AnimeCategoriesButtonsView()) {
                    HStack{
                        
                        Image(systemName: "square.grid.2x2.fill")
                        Text("Genres")
                    }
                    
                    .foregroundStyle(Color("accountNavColor"))
                    
                }
                
            }
        }
            .background(Color("background"))
            .foregroundStyle(.white)
    }
}

#Preview {
    DiscoverView()
}
