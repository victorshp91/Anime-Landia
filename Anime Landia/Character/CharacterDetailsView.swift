//
//  CharacterDetailsView.swift
//  Anime Landia
//
//  Created by Victor Saint Hilaire on 9/30/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct CharacterDetailsView: View {
    let character: CharacterStruct.AnimeCharacter
    @State private var isShowingFullBio = false
    @State private var showAvatar = false
    
    // PARA MANEJAR EL COLOR DEL DARK MODE
    
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
                   VStack(spacing: 20) {
                       if showAvatar {
                           WebImage(url: URL(string: character.images?.jpg.image_url ?? ""))
                               .resizable()
                               .scaledToFill()
                               .frame(width: 250, height: 250)
                               .clipShape(Circle())
                               .overlay(Circle().stroke(Color("barColor"), lineWidth: 3)) // Optional: Add a border
                               .shadow(radius: 5)
                       }
                       
                       VStack(alignment: .center, spacing: 10) {
                           Text(character.name ?? "N/A")
                               .font(.largeTitle)
                               .bold()
                               .foregroundStyle(.white)
                           
                           // DESCRIPTION
                           Text(isShowingFullBio ? character.about ?? "N/A" : HelpersFunctions().truncateText(text: character.about ?? "N/A"))
                               .padding()
                               .font(.body)
                               .foregroundColor(.white)
                               .multilineTextAlignment(.leading)
                               .lineSpacing(5)
                               .fixedSize(horizontal: false, vertical: true)
                               .frame(maxWidth: .infinity)
                               .background(RoundedRectangle(cornerRadius: 10).fill(Color("barColor")))
                               
                               
                           
                           // Expand/Collapse Button (Moved to the background)
                           Button(action: {
                               withAnimation {
                                   isShowingFullBio.toggle()
                               }
                           }) {
                               Image(systemName: isShowingFullBio ? "arrow.up.circle.fill" : "arrow.down.circle.fill")
                                   .font(.system(size: 22))
                                   .foregroundStyle(.white)
                           }
                           
                           CharacterAnimeListView(characterId: character.mal_id ?? 0)
                               .padding(.vertical)
                               .foregroundColor(.secondary)
                               
                               .background(RoundedRectangle(cornerRadius: 10).fill(Color("barColor")))
                       }
                   }
                   .padding()
                   .frame(maxWidth: .infinity)
               }
              
                .background(Color("background"))
                .toolbar(.hidden, for: .tabBar)
            .navigationTitle("Details")
            .onAppear(perform: {
                withAnimation {
                   
                    showAvatar = true
                }
            })
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack{
                        if let id = character.id {
                            FavoriteButtonView(favoriteFor: .character, idCharacterOrAnime: id)
                        }
                        ShareLink(item: (URL(string: character.url ?? "N/A")!)) {
                            Image(systemName: "square.and.arrow.up.circle.fill")
                            
                                .font(.title2)
                                .foregroundStyle(Color("accountNavColor"))
                                
                        }
                    }
                    
                    
                }
            }.toolbarBackground(
                Color("barColor"),
                for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        
    }
}

#Preview {
    CharacterDetailsView(character: CharacterStruct.AnimeCharacter(mal_id: 50))
}
