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
    var animeId: Int
    var body: some View {
        Button (action:{
            isFavorite.toggle()
            guardarFavorito()
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
        if let url = URL(string: "https://rayjewelry.us/api.php?id_usuario=\(1)&id_anime=\(animeId)&favorite=true") {
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
        let urlString = "https://rayjewelry.us/guardar_favorito_watching.php?id_usuario=\(1)&id_anime=\(animeId)&favorite=\(isFavorite ? 1:0)"
            
            
            if let url = URL(string: urlString) {
                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                    if let error = error {
                        print("Error en la solicitud HTTP: \(error)")
                    } else if let data = data {
                        if let responseString = String(data: data, encoding: .utf8) {
                            print(data)
                            print("Respuesta del servidor: \(responseString)")
                        }
                    }
                }
                task.resume()
            }
        }
}

#Preview {
    FavoriteButtonView(animeId: 1)
}
