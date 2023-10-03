//
//  TopRatingView.swift
//  Anime Landia
//
//  Created by Victor Saint Hilaire on 9/30/23.
//

import SwiftUI

struct RandomAnimeView: View {
    @State private var animeData: [Anime]?
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        
    }
    
    func loadData() {
        
        guard let url = URL(string: "https://api.jikan.moe/v4/top/anime?filter=\(showing.rawValue)&limit=10&sfw=true") else {
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode(AnimeData.self, from: data)
                    DispatchQueue.main.async {
                        self.animeData = decodedData.data
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
    RandomAnimeView()
}
