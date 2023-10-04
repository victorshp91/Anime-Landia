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
    var body: some View {
        ScrollView(.vertical) {
                   VStack(spacing: 20) {
                       if showAvatar {
                           WebImage(url: URL(string: character.images?.jpg.image_url ?? ""))
                               .resizable()
                               .scaledToFill()
                               .frame(width: 250, height: 250)
                               .clipShape(Circle())
                               .overlay(Circle().stroke(Color.cyan, lineWidth: 3)) // Optional: Add a border
                               .shadow(radius: 5)
                       }
                       
                       VStack(alignment: .center, spacing: 10) {
                           Text(character.name ?? "N/A")
                               .font(.largeTitle)
                               .bold()
                           
                           // DESCRIPTION
                           Text(isShowingFullBio ? character.about ?? "N/A" : HelpersFunctions().truncateText(text: character.about ?? "N/A"))
                               .padding()
                               .font(.body)
                               .foregroundColor(.secondary)
                               .multilineTextAlignment(.center)
                               .lineSpacing(5)
                               .fixedSize(horizontal: false, vertical: true)
                               .frame(maxWidth: .infinity)
                               .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                               
                               
                           
                           // Expand/Collapse Button (Moved to the background)
                           Button(action: {
                               withAnimation {
                                   isShowingFullBio.toggle()
                               }
                           }) {
                               Image(systemName: isShowingFullBio ? "arrow.up.circle.fill" : "arrow.down.circle.fill")
                                   .font(.system(size: 24))
                                   .foregroundColor(.black)
                                   .background(Color.white) // Set the background color here
                                   .clipShape(Circle())
                                   .padding()
                                   .shadow(radius: 3)
                           }
                           
                           CharacterAnimeListView(characterId: character.mal_id ?? 0)
                               .padding()
                               .foregroundColor(.secondary)
                               .frame(maxWidth: .infinity)
                               .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                       }
                   }
                   .padding()
                   .frame(maxWidth: .infinity)
               }
              
                .background(Color.gray.opacity(0.1))
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
                        Image(systemName: "heart")
                            .font(.title2)
                            .foregroundStyle(.cyan)
                        ShareLink(item: (URL(string: character.url ?? "N/A")!)) {
                            Image(systemName: "square.and.arrow.up.circle.fill")
                            
                                .font(.title2)
                                .foregroundStyle(.cyan)
                                
                        }
                    }
                    
                    
                }
            }
        
    }
}

#Preview {
    CharacterDetailsView(character: CharacterStruct.AnimeCharacter(mal_id: 50))
}
