//
//  CharacterAnimeListView.swift
//  Anime Landia
//
//  Created by Victor Saint Hilaire on 10/1/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct CharacterAnimeListView: View {
    let characterId: Int
    @State private var animeDataList: [AnimeForCharacter.AnimeItem]?
    
    var body: some View {
        
        VStack(alignment: .leading) {
            if let data = animeDataList {
                Text("Character's Animes")
                    .bold()
                    .padding(.horizontal)
                ScrollView(.horizontal, showsIndicators: false){
                    
                    LazyHStack {
                        
                        ForEach(data, id: \.anime.mal_id) { anime in
                            VStack(alignment: .leading) {
                                WebImage(url: URL(string: anime.anime.images.jpg.image_url))
                                    .resizable()
                                    .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                                    .frame(maxWidth: 150, maxHeight: 200)
                                    .scaledToFill()
                                    .shadow(radius: 3)
                                   
                             
                                Text(anime.anime.title)
                                    .font(.caption)
                                    .lineLimit(1)
                                HStack(spacing: 5){
                                    Text("Role")
                                        .foregroundStyle(.red)
                                    Text(anime.role)
                                      
                                        .bold()
                                }  .font(.caption)
                                Spacer()
                            }
                            .frame(maxWidth: 150) // Establece el tamaño máximo para cada elemento
                            
                        }
                       
                    }.padding(.top)
                    
                }
            }else {
                CustomLoadingView().padding() // Muestra el indicador de carga personalizado
                
            }
            
            Spacer()
            
        }.foregroundStyle(.white)
        .onAppear(perform: loadData)
               // .navigationTitle("Discover")
    }

    func loadData() {
        guard let url = URL(string: "https://api.jikan.moe/v4/characters/\(characterId)/anime") else {
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode(AnimeForCharacter.AnimeData.self, from: data)
                    DispatchQueue.main.async {
                        self.animeDataList = decodedData.data
                    }
                } catch {
                    print("Error al decodificar los datos: \(error)")
                }
            } else if let error = error {
                print("Error al cargar los datos: \(error)")
            }
        }.resume()
    }
}

#Preview {
    CharacterAnimeListView(characterId: 51)
}
