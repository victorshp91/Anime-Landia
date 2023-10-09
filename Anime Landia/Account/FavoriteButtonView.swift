//
//  FavoriteButtonView.swift
//  Anime Landia
//
//  Created by Victor Saint Hilaire on 10/4/23.
//

import SwiftUI

struct FavoriteButtonView: View {
    @State private var favoritos: [Favorito] = []
    @State private var isFavorite = false
    var favoriteFor: HelpersFunctions.searchingType
    var idCharacterOrAnime: Int
    var body: some View {
        Button (action:{
            if !AccountVm.sharedUserVM.userActual.isEmpty {
                isFavorite.toggle()
                guardarFavorito()
            } else {
                print("Need an Account")
            }
           
        }) {
            Image(systemName: isFavorite ? "heart.fill":"heart")
                .font(.title2)
                .symbolEffect(.bounce, options: .speed(1).repeat(3), value: !favoritos.isEmpty)
                
        }
        .onAppear(perform: {
            verificarFavorito()
        })
    }
    
    func verificarFavorito() {
        if let url = URL(string: favoriteFor == .anime ? "\(DataBaseViewModel.sharedDataBaseVM.hosting)\(DataBaseViewModel.sharedDataBaseVM.getIfAnimeIsFavorite)id_usuario=\(AccountVm.sharedUserVM.userActual.first?.id ?? "")&id_anime=\(idCharacterOrAnime)&favorite=true":"\(DataBaseViewModel.sharedDataBaseVM.hosting)\(DataBaseViewModel.sharedDataBaseVM.getIfCharactersIsFavorites)id_usuario=\(AccountVm.sharedUserVM.userActual.first?.id ?? "")&id_character=\(idCharacterOrAnime)&favorite=true") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                  
                    do {
                        let favoritosData = try JSONDecoder().decode([Favorito].self, from: data)
                
                        DispatchQueue.main.async {
                            self.favoritos = favoritosData
                            self.isFavorite = ((favoritosData.first?.favorite) != nil)
                        }
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                }
            }.resume()
        }
    }
    
    func guardarFavorito() {
        let urlString = favoriteFor == .anime ? "\(DataBaseViewModel.sharedDataBaseVM.hosting)\(DataBaseViewModel.sharedDataBaseVM.saveWatchingStatusOrFavorite)id_usuario=\(AccountVm.sharedUserVM.userActual.first?.id ?? "")&id_anime=\(idCharacterOrAnime)&favorite=\(isFavorite ? 1:0)":"\(DataBaseViewModel.sharedDataBaseVM.hosting)\(DataBaseViewModel.sharedDataBaseVM.saveCharacterAsFavorite)id_usuario=\(AccountVm.sharedUserVM.userActual.first?.id ?? "")&id_character=\(idCharacterOrAnime)&favorite=\(isFavorite ? 1:0)"
            
            
            if let url = URL(string: urlString) {
                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                    if let error = error {
                        print("Error en la solicitud HTTP: \(error)")
                    } else if let data = data {
                        if let responseString = String(data: data, encoding: .utf8) {
                            print(data)
                            print("Respuesta del servidor: \(responseString)")
                            
                            // Llama a la función para aumentar o disminuir el valor de favorito en la tabla que lleva lo cuenta de totales de todos los usuarios
                            AccountVm.sharedUserVM.updateWatchingStatusNumbers(idAnime: idCharacterOrAnime, campo: "favorites", accion: isFavorite ? "aumentar":"disminuir") { result in
                                                switch result {
                                                case .success(let message):
                                                   print(message)
                                                case .failure(let error):
                                                    print(error.localizedDescription)
                                                }
                                            }
                        }
                    }
                }
                task.resume()
            }
        }
}

#Preview {
    FavoriteButtonView(favoriteFor: .anime, idCharacterOrAnime: 1)
}
