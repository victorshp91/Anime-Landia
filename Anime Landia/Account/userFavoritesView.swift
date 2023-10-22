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
          
                obtenerFavoritos(isFor: isFor)
            
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
    private func fetch(Id: Int, isFor: HelpersFunctions.searchingType) {
        let urlString: String
        if isFor == .anime {
            urlString = "https://api.jikan.moe/v4/anime/\(Id)"
        } else {
            urlString = "https://api.jikan.moe/v4/characters/\(Id)"
        }
        
        guard let url = URL(string: urlString) else {
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
                           
                                allCharacters.append(character)
                            
                        }
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }
        }.resume()
    }

    func obtenerFavoritos(isFor: HelpersFunctions.searchingType) {
        allAnimes = []
        allCharacters = []
        ratingAverage = [:]
        
     
            isLoading = true
        
        
        let idUsuario = AccountVm.sharedUserVM.userActual.first?.id ?? ""
        let url: URL
        
        if isFor == .anime {
            url = URL(string: "\(DataBaseViewModel.sharedDataBaseVM.Dominio)\(DataBaseViewModel.sharedDataBaseVM.getIfAnimeIsFavorite)id_usuario=\(idUsuario)&favorite=true") ?? URL(string: "")!
        } else {
            url = URL(string: "\(DataBaseViewModel.sharedDataBaseVM.Dominio)\(DataBaseViewModel.sharedDataBaseVM.getIfCharactersIsFavorites)id_usuario=\(idUsuario)&favorite=true") ?? URL(string: "")!
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let decodedData = try decoder.decode([Favorito].self, from: data)
                    
                    DispatchQueue.main.async {
                        for favorito in decodedData {
                            if let id = isFor == .anime ? favorito.id_anime : favorito.id_character {
                                fetch(Id: id, isFor: isFor)
                            }
                        }
                        
                        if isFor == .anime {
                            for anime in decodedData {
                                AnimeVM.sharedAnimeVM.fetchRatingsForAnime(animeId: anime.id_anime ?? 0, isAverage: true, page: "1") { rating in
                                    if let average = rating.average {
                                        ratingAverage["\(anime.id_anime ?? 0)"] = average
                                    }
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


#Preview {
    userFavoritesView(isFor: .anime)
}
