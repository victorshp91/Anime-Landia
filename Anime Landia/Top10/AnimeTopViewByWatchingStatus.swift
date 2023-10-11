//
//  AnimeTopView.swift
//  Anime Landia
//
//  Created by Victor Saint Hilaire on 10/9/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct AnimeTopViewByWatchingStatus: View {
    @State private var animeWatchingStatus: [AnimeWatchingStatusTotals]?
    @State private var allAnimes: [Anime] = []
    var watchingStatus: HelpersFunctions.animeWatchingOptions
    
    var body: some View {
        VStack(alignment: .leading){
            if !allAnimes.isEmpty {
                VStack(alignment: .leading){
                    HStack{
                        Text("\(watchingStatus.rawValue.capitalized)")
                            .bold()
                        Image(systemName: AnimeWatchingButton(animeId: 0, selectedOption: watchingStatus, changeOptionImageSize: 20).icoImage)
                            .font(.title2)
                            .foregroundStyle(AnimeWatchingButton(animeId: 0, selectedOption: watchingStatus, changeOptionImageSize: 20).iconColor)
                    }
                    switch watchingStatus {
                    case .watching:
                        Text("Top 10 animes that the users are currently watching.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    case .hold:
                        Text("Top 10 animes the users plan to watch in the near future.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    case .completed:
                        Text("Top 10 animes the users have completed.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    case .none:
                        Text("")
                    }
                    
                }.padding(.horizontal)
                
                
                ScrollView(.horizontal, showsIndicators: false){
                    
                    LazyHStack{
                        Spacer()
                        ForEach(allAnimes) { anime in
                            
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
             
            
                    
                    HelpersFunctions().loadingView()
                
                
            }
            
        }.onAppear(perform: {
            getWatchingStatus()
            
        })
    }
    
    func getWatchingStatus() {
        allAnimes = []
        guard let url = URL(string: "\(DataBaseViewModel.sharedDataBaseVM.hosting)\(DataBaseViewModel.sharedDataBaseVM.getTopAnimeByWatchingStatus)campo=\(watchingStatus.rawValue.lowercased())") else {
                return
            }
            
            URLSession.shared.dataTask(with: url) { data, _, error in
              
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let decodedData = try decoder.decode([AnimeWatchingStatusTotals].self, from: data)
                        DispatchQueue.main.async {
                            self.animeWatchingStatus = decodedData
                            
                            for anime in decodedData {
                                if let idAnime = anime.id_anime {
                                    fetch(Id: idAnime)
                                    // pomemos de el estado del watching obtenido de la base de datos
                                }
                            }
                            
                            print(allAnimes.count)
                            
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
                              
                              if allAnimes.count < 10 {  // Verifica si hay menos de 10 elementos
                                  allAnimes.append(anime)
                              }

                              
                          }
                      
                      
                      
                  } catch {
                      print("Error decoding JSON: \(error)")
                  }
              }
          }.resume()
      }
    }


#Preview {
    AnimeTopViewByWatchingStatus(watchingStatus: .watching)
}
