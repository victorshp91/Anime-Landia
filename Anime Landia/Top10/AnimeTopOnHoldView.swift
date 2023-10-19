//
//  AnimeTopOnHoldView.swift
//  AnimeTracker Pro
//
//  Created by Victor Saint Hilaire on 10/17/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct AnimeTopOnHoldView: View {
    
    @State private var allOnHoldTopAnime: [Anime] = []
  
    var body: some View {
        VStack(alignment: .leading){
            if !allOnHoldTopAnime.isEmpty {
                VStack(alignment: .leading){
                    HStack{
                        Text("On Hold")
                            
                        Image(systemName: AnimeWatchingButton(animeId: 0, selectedOption: .hold, changeOptionImageSize: 20).icoImage)
                            .font(.title2)
                            .foregroundStyle(AnimeWatchingButton(animeId: 0, selectedOption: .hold, changeOptionImageSize: 20).iconColor)
                    }.font(.title2)
                        
                        .bold()
                   
                    
                        Text("Top animes that the users plan to watch in the near future")
                            .font(.caption)
                   
                    
                }.padding(.horizontal,8)
                
                
                ScrollView(.horizontal, showsIndicators: false){
                    
                    HStack{
                        Spacer()
                        ForEach(allOnHoldTopAnime) { anime in
                            
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
                                }.id(UUID())
                                .frame(maxWidth: 150)
                                
                            }
                            
                        
                        }
                        Spacer()
                    }.padding(.vertical)
                    
                }
            }else {
             
            
                    
                CustomLoadingView().padding() // Muestra el indicador de carga personalizado
                
                
            }
            
        }.onAppear(perform: {
            getWatchingStatus()
            
        })
    }
    
    func getWatchingStatus() {
        allOnHoldTopAnime = []
        guard let url = URL(string: "\(DataBaseViewModel.sharedDataBaseVM.Dominio)\(DataBaseViewModel.sharedDataBaseVM.getTopAnimeByWatchingStatus)campo=\(HelpersFunctions.animeWatchingOptions.hold.rawValue.lowercased())") else {
                return
            }
            
            URLSession.shared.dataTask(with: url) { data, _, error in
              
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let decodedData = try decoder.decode([AnimeWatchingStatusTotals].self, from: data)
                        DispatchQueue.main.async {
                            for anime in decodedData {
                                if let idAnime = anime.id_anime {
                                    fetch(Id: idAnime)
                                    // pomemos de el estado del watching obtenido de la base de datos
                                }
                            }
                            
                          
                            
                        }
                    } catch {
                        print("Error de decodificación: \(error)")
                    }
                } else if let error = error {
                    print("Error de solicitud: \(error)")
                }
            }.resume()
        }
    
    // Function to fetch the JSON data from the URL
    private func fetch(Id: Int) {
        guard let url = URL(string:"https://api.jikan.moe/v4/anime/\(Id)") else {
              return
          }
          
          URLSession.shared.dataTask(with: url) { data, response, error in
              if let data = data {
                  do {
                      
                          let animeResponse = try JSONDecoder().decode(OnlyAnimeData.self, from: data)
                          let anime = animeResponse.data
                          DispatchQueue.main.async {
                              
                             
                              allOnHoldTopAnime.append(anime ?? .init())
                              
                          }
                      
                      
                      
                  } catch {
                      print("Error decoding JSON: \(error)")
                  }
              }
          }.resume()
      }
}

#Preview {
    AnimeTopOnHoldView()
}
