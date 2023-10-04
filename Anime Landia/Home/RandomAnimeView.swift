//
//  TopRatingView.swift
//  Anime Landia
//
//  Created by Victor Saint Hilaire on 9/30/23.
//

import SwiftUI
import SDWebImageSwiftUI
struct RandomAnimeView: View {
    
    @State private var randomAnime: Anime?
    @State private var hasLoadedData = false
    
    var body: some View {
        VStack(alignment: .leading){
            
            if let data = randomAnime{
                
                VStack(alignment: .leading) {
                    Text("RANDOM ANIME")
                    .bold()
                    .font(.callout)
                            HStack(alignment: .top, spacing: 10) {
                                WebImage(url: URL(string: data.images?.jpg.large_image_url ?? ""))
                                    .resizable()
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .frame(width: 150, height: 230)
                                    .scaledToFill()
                                    .shadow(radius: 5)
                                
                                VStack(alignment: .leading, spacing: 10) {
                                    Text(data.title ?? "N/A")
                                        .font(.title)
                                        .bold()
                                        .lineLimit(2)
                                    HStack {
                                        Image(systemName: "star.fill")
                                            .foregroundColor(.yellow)
                                        Text(String(format: "%.2f", data.score ?? 0))
                                            .bold()
                                    }
                                    .font(.title)
                                    
                                    Text("Rating: \(data.rating ?? "N/A")")
                                        .font(.subheadline)
                                        
                                    
                                    Spacer()
                                    HStack{
                                        Spacer()
                                        NavigationLink(destination: AnimeDetailsView(anime: data)) {
                                            Image(systemName: "eye.circle.fill")
                                                .font(.largeTitle)
                                        }
                                        
                                        Button(action: {
                                            loadData()
                                        }){
                                            Image(systemName: "shuffle.circle.fill")
                                                .font(.largeTitle)
                                        }
                                    }
                                }
                                .padding(.trailing, 10)
                            }.frame(maxWidth: .infinity)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.cyan)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                
                
            } else {
                HelpersFunctions().loadingView()
            }
            Spacer()
        }.onAppear(perform: {
            if !hasLoadedData {
                                    loadData()
                                    hasLoadedData = true
                                }
        })
    }
    
    func loadData() {
        
        guard let url = URL(string: "https://api.jikan.moe/v4/random/anime") else {
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode(OnlyAnimeData.self, from: data)
                    DispatchQueue.main.async {
                        self.randomAnime = decodedData.data
                        
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
