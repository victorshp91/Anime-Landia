//
//  userFavoritesView.swift
//  Anime Landia
//
//  Created by Victor Saint Hilaire on 10/6/23.
//

import SwiftUI
import SDWebImageSwiftUI
struct userFavoritesAnimeView: View {
    @State private var allAnimes: [Anime]?
    @State private var allCharacters: [CharacterStruct.AnimeCharacter]?
    var isFor: HelpersFunctions.searchingType
    var body: some View {
        
        ScrollView(.vertical) {
            if isFor == .anime {
                if let favoritesAnime = allAnimes
                {
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
                        ForEach(favoritesAnime.reversed(), id: \.id) { item in
                            NavigationLink(destination: AnimeDetailsView(anime: item)) {
                                WebImage(url: URL(string: item.images?.jpg.large_image_url  ?? ""))
                                    .resizable()
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .frame(width: 150, height: 230)
                                    .scaledToFill()
                                    .shadow(radius: 5)
                            }
                        }
                    }
                    .padding()
                } else {
                    HelpersFunctions().loadingView()
                }
            } else {
                
                if let favoritesCharacters = allCharacters
                {
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
                        ForEach(favoritesCharacters.reversed(), id: \.id) { item in
                            NavigationLink(destination: CharacterDetailsView(character: item)) {
                                WebImage(url: URL(string: item.images?.jpg.image_url ?? ""))
                                    .resizable()
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .frame(width: 150, height: 230)
                                    .scaledToFill()
                                    .shadow(radius: 5)
                            }
                        }
                    }
                    .padding()
                } else {
                    HelpersFunctions().loadingView()
                }

                
            }
        }
        .frame(maxWidth: .infinity)
        .onAppear {
          
                obtenerFavoritos()
            
        }
        .navigationTitle(isFor == .anime ? "Favorites Anime":"Favorites Characters")
        .background(Color.gray.opacity(0.1))
        .toolbar(.hidden, for: .tabBar)
    }
    
    // Function to fetch the JSON data from the URL
    private func fetch(Id: Int) {
        guard let url = URL(string: isFor == .anime ?  "https://api.jikan.moe/v4/anime/\(Id)": "https://api.jikan.moe/v4/characters/\(Id)") else {
              return
          }
          
          URLSession.shared.dataTask(with: url) { data, response, error in
              if let data = data {
                  do {
                      if isFor == .anime {
                          let animeResponse = try JSONDecoder().decode(OnlyAnimeData.self, from: data)
                          let anime = animeResponse.data
                          DispatchQueue.main.async {
                              
                              self.allAnimes?.append(anime)
                              
                          }
                      } else {
                          let characterResponse = try JSONDecoder().decode(CharacterStruct.OnlyCharacterData.self, from: data)
                          let character = characterResponse.data
                          DispatchQueue.main.async {
                              
                              self.allCharacters?.append(character)
                              
                          }
                      }
                  } catch {
                      print("Error decoding JSON: \(error)")
                  }
              }
          }.resume()
      }
    
    func obtenerFavoritos() {
        if let url = URL(string: isFor == .anime ? "https://rayjewelry.us/get_anime_favorite_watching.php?id_usuario=\(1)&favorite=true":"https://rayjewelry.us/get_characters_favorites.php?id_usuario=\(1)&favorite=true") {
                URLSession.shared.dataTask(with: url) { data, response, error in
                    if let data = data {
                        let decoder = JSONDecoder()
                        do {
                            let decodedData = try decoder.decode([Favorito].self, from: data)
                    
                            DispatchQueue.main.async {
                                if isFor == .anime {
                                    allAnimes = []
                                    for favorito in decodedData {
                                        if let idAnime = favorito.id_anime {
                                            fetch(Id: idAnime)
                                            // pomemos de el estado del watching obtenido de la base de datos
                                        }
                                    }
                                } else {
                                    allCharacters = []
                                    for favorito in decodedData {
                                        if let idCharacter = favorito.id_character {
                                            fetch(Id: idCharacter)
                                            // pomemos de el estado del watching obtenido de la base de datos
                                        }
                                    }
                                    
                                }
                            
                            }
                        } catch {
                            print("Error al decodificar el JSON: \(error)")
                        }
                    } else if let error = error {
                        print("Error en la solicitud HTTP: \(error)")
                    }
                }.resume()
            }
        }
  }


#Preview {
    userFavoritesAnimeView(isFor: .anime)
}
