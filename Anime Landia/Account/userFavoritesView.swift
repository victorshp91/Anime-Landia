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
    @State private var ratingAverage = [String:Double]()
    @State private var allCharacters: [CharacterStruct.AnimeCharacter] = []
    @State private var isLoading = false
    @State private var showNoData = false
    var isFor: HelpersFunctions.searchingType
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            
            if isLoading {
                CustomLoadingView().padding() // Muestra el indicador de carga personalizado
            }
            if showNoData {
                HelpersFunctions.NoDataView()
                    .padding()
            }
            
            if isFor == .anime {
                if  !allAnimes.isEmpty
                {
                    SearchView().animeListView(animes: allAnimes, ratingAverage: ratingAverage).padding()
                }
            } else {
                
                if !allCharacters.isEmpty
                {
                    
                    SearchView().characterListView(characters: allCharacters).padding()
                  
                }

                
            }
        }
        .frame(maxWidth: .infinity)
        .onAppear {
          
                obtenerFavoritos()
            
        }
        //.navigationTitle(isFor == .anime ? "Favorites Anime":"Favorites Characters")
        .background(Color("background"))
        .toolbar(.hidden, for: .tabBar)
        .navigationTitle("Favorites")
        .toolbarBackground(
            Color("barColor"),
            for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)

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
                              
                             
                              allAnimes.append(anime ?? .init())
                              
                              
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
        ratingAverage = [:]
        
        withAnimation {
            isLoading = true
        }
        if let url = URL(string: isFor == .anime ? "\(DataBaseViewModel.sharedDataBaseVM.Dominio)\(DataBaseViewModel.sharedDataBaseVM.getIfAnimeIsFavorite)id_usuario=\(AccountVm.sharedUserVM.userActual.first?.id ?? "")&favorite=true":"\(DataBaseViewModel.sharedDataBaseVM.Dominio)\(DataBaseViewModel.sharedDataBaseVM.getIfCharactersIsFavorites)id_usuario=\(AccountVm.sharedUserVM.userActual.first?.id ?? "")&favorite=true") {
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
                                    
                                    for anime in decodedData{
                                        AnimeVM.sharedAnimeVM.fetchRatingsForAnime(animeId: anime.id_anime ?? 0, isAverage: true, page: "1", completion: { rating in
                                            if let average = rating.average{
                                                ratingAverage["\(anime.id_anime ?? 0)"] = average
                                            }
                                            
                                            
                                        })
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
