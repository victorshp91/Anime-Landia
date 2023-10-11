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
    @State private var eTag: String? // Almacena la ETag actual
    var showing = showingTop.airing
    
    enum showingTop: String {
        case airing = "Airing"
        case upcoming = "Upcoming"
        case topRating = "Rating"
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
            if let data = animeData{
                Text("Top 10 \(showing.rawValue)")
                    .bold()
                    .padding(.horizontal)
                
                
                ScrollView(.horizontal, showsIndicators: false){
                    
                    LazyHStack{
                        Spacer()
                        ForEach(data) { anime in
                            
                            NavigationLink(destination: AnimeDetailsView(anime: anime)) {
                                
                                VStack{
                                    WebImage(url: URL(string: anime.images?.jpg.large_image_url ?? "NO DATA"))
                                        .resizable()
                                        .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                                        .frame(minWidth: 150, minHeight: 200)
                                        .scaledToFit()
                                        .shadow(radius: 3)
                                    
                                    Text("\(anime.title ?? "NO DATA")")
                                        .font(.caption)
                                        .lineLimit(1)
                                            .truncationMode(.tail)
                                    Spacer()
                                }.frame(maxWidth: 150)
                                
                            }
                            
                        
                        }
                        Spacer()
                    }.padding(.vertical)
                    
                }
            }else {
                // PARA QUE SOLO LO PRESENTE ARRIBA EL LOADING
                if showing == showingTop.airing{
                    
                    HelpersFunctions().loadingView()
                }
                
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
        
        var request = URLRequest(url: url)
        
        // Agrega la ETag almacenada a la solicitud si está disponible
        if let eTag = eTag {
            request.addValue(eTag, forHTTPHeaderField: "If-None-Match")
            
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    // Data has changed, update the UI and store the new ETag
                    if let data = data {
                        do {
                            let decodedData = try JSONDecoder().decode(AnimeData.self, from: data)
                            DispatchQueue.main.async {
                                self.animeData = decodedData.data
                                
                            }
                            // Almacena la nueva ETag localmente
                            if let newETag = response.allHeaderFields["ETag"] as? String {
                                self.eTag = newETag
                                print(newETag)
                            }
                        } catch {
                            print("Error al decodificar los datos: \(error)")
                        }
                    }
                } else if response.statusCode == 304 {
                    // Content has not changed, no need to update anything
                   
                } else {
                    // Handle other status codes or errors
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
