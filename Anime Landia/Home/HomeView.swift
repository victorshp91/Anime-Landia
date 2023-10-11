//
//  AnimeMenuVuew.swift
//  Anime Landia
//
//  Created by Victor Saint Hilaire on 9/30/23.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack{
                RandomAnimeView()
               
                RandomCharacterView()
             
                Spacer()
            }.padding(.horizontal)
              
            
        }.frame(maxWidth: .infinity)

           .navigationTitle("AnimeTracker Pro")
           .background(Color.gray.opacity(0.1))
           .onAppear(perform: {
               print(AccountVm.sharedUserVM.userActual)
           })
           
       }
   }

   struct ButtonMenu: View {
       let title: String
       
       var body: some View {
           HStack{
               Image(systemName: "magnifyingglass.circle.fill")
               Text(title)
               Spacer()
           }.font(.callout)
           
          
               .padding()
               .frame(maxWidth: .infinity)
               .background(Color.blue)
               .foregroundColor(.white)
               .cornerRadius(10)
             
       }
   }

#Preview {
    HomeView()
}
