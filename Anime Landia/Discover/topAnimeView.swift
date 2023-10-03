//
//  ContentView.swift
//  Anime Landia
//
//  Created by Victor Saint Hilaire on 9/30/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct topAnimeView: View {
    
    @State private var animeData: [Anime]?
    
    var showing = showingTop.airing
    
    enum showingTop: String {
        case airing = "Airing"
        case upcoming = "Upcoming"
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
            if let data = animeData{
                Text("Top 10 \(showing.rawValue)")
                    .bold()
                
                
                ScrollView(.horizontal, showsIndicators: false){
                    
                    LazyHStack{
                        ForEach(data) { anime in
                            VStack(alignment: .leading){
                                WebImage(url: URL(string: anime.images?.jpg.large_image_url ?? "NO DATA"))
                                    .resizable()
                                    .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                                    .frame(maxWidth: 150, maxHeight: 200)
                                    .scaledToFit()
                                    
                                
                                
                                Text("\(anime.title ?? "NO DATA")")
                                    .font(.caption)
                                Spacer()
                            }.frame(maxWidth: 150)
                        }
                    }
                    
                }
            }else {
                Text("Cargando datos...")
                
            }
            
            Spacer()
            
        }
        .onAppear(perform: loadData)
                .navigationTitle("Discover")
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
    topAnimeView()
}
