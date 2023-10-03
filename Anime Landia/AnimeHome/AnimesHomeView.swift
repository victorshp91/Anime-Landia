//
//  AnimeMenuVuew.swift
//  Anime Landia
//
//  Created by Victor Saint Hilaire on 9/30/23.
//

import SwiftUI

struct AnimesHomeView: View {
    var body: some View {
           
               VStack{
                  
               }
               .toolbar {
                   ToolbarItem(placement: .navigationBarTrailing) {
                       Image(systemName: "magnifyingglass")
                           .font(.title2)
                           .foregroundStyle(.cyan)
                           
                       }
                   }
               

           
           .navigationTitle("Anime")
           
       }
   }

   struct ListItem: View {
       let title: String
       
       var body: some View {
           Text(title)
               .font(.title2)
               .padding()
               .background(Color.cyan)
               .foregroundColor(.white)
               .cornerRadius(10)
               .shadow(radius: 5) // Efecto de sombra
       }
   }

#Preview {
    AnimesHomeView()
}
