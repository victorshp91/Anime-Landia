//
//  userFavoritesView.swift
//  Anime Landia
//
//  Created by Victor Saint Hilaire on 10/6/23.
//

import SwiftUI
import SDWebImageSwiftUI
struct userFavoritesView: View {
    
    @State private var allAnimes: [Anime] = []
    @State private var allCharacters: [CharacterStruct.AnimeCharacter] = []
    @State private var isLoading = false
    @State private var showNoData = false
    var isFor: HelpersFunctions.searchingType
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            
            if isLoading {
                HelpersFunctions().loadingView()
            }
            if showNoData {
                HelpersFunctions.NoDataView()
                    .padding()
            }
            
            if isFor == .anime {
                if  !allAnimes.isEmpty
                {
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
                        ForEach(allAnimes.reversed(), id: \.id) { item in
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
                }
            } else {
                
                if !allCharacters.isEmpty
                {
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
                        ForEach(allCharacters.reversed(), id: \.id) { item in
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
                              
                              if allAnimes.count < 10 {  // Verifica si hay menos de 10 elementos
                                                  allAnimes.append(anime)
                              }
                          }
                      } else {
                          let characterResponse = try JSONDecoder().decode(CharacterStruct.OnlyCharacterData.self, from: data)
                          let character = characterResponse.data
                          DispatchQueue.main.async {
                              if allCharacters.count < 10 {  // Verifica si hay menos de 10 elementos
                                  self.allCharacters.append(character)
                              }
                              
                              
                          }
                      }
                  } catch {
                      print("Error decoding JSON: \(error)")
                  }
              }
          }.resume()
      }
    
    func obtenerFavoritos() {
        allAnimes = []
        allCharacters = []
        
        withAnimation {
            isLoading = true
        }
        if let url = URL(string: isFor == .anime ? "\(DataBaseViewModel.sharedDataBaseVM.hosting)\(DataBaseViewModel.sharedDataBaseVM.getIfAnimeIsFavorite)id_usuario=\(AccountVm.sharedUserVM.userActual.first?.id ?? "")&favorite=true":"\(DataBaseViewModel.sharedDataBaseVM.hosting)\(DataBaseViewModel.sharedDataBaseVM.getIfCharactersIsFavorites)id_usuario=\(AccountVm.sharedUserVM.userActual.first?.id ?? "")&favorite=true") {
            print(url)
                URLSession.shared.dataTask(with: url) { data, response, error in
                    if let data = data {
                        let decoder = JSONDecoder()
                        do {
                            let decodedData = try decoder.decode([Favorito].self, from: data)
                    
                            DispatchQueue.main.async {
                                if isFor == .anime {
                                    
                                    for favorito in decodedData {
                                        if let idAnime = favorito.id_anime {
                                            fetch(Id: idAnime)
                                            // pomemos de el estado del watching obtenido de la base de datos
                                        }
                                    }
                                } else {
                                    
                                    for favorito in decodedData {
                                        if let idCharacter = favorito.id_character {
                                            fetch(Id: idCharacter)
                                            // pomemos de el estado del watching obtenido de la base de datos
                                        }
                                    }
                                    
                                }
                                
                               
                                isLoading = false
                            }
                        } catch {
                            isLoading = false
                            showNoData = true
                            print("Error al decodificar el JSON: \(error)")
                        }
                    } else if let error = error {
                        isLoading = false
                        showNoData = true
                        print("Error en la solicitud HTTP: \(error)")
                    }
                }.resume()
            }
        }
  }


#Preview {
    userFavoritesView(isFor: .anime)
}
