//
//  AnimeTopView.swift
//  Anime Landia
//
//  Created by Victor Saint Hilaire on 10/9/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct AnimeTopWatchingView: View {
 
    @State private var allWatchingTopAnime: [Anime] = []
  
    
    var body: some View {
        VStack(alignment: .leading){
            if !allWatchingTopAnime.isEmpty {
                VStack(alignment: .leading){
                    HStack{
                        Text("Watching")
                            
                        Image(systemName: AnimeWatchingButton(animeId: 0, selectedOption: .watching, changeOptionImageSize: 20).icoImage)
                            .font(.title2)
                            .foregroundStyle(AnimeWatchingButton(animeId: 0, selectedOption: .watching, changeOptionImageSize: 20).iconColor)
                    }.font(.title2)
                        
                        .bold()
                   
                    
                        Text("Top animes that the users are currently watching")
                            .font(.caption)
                   
                    
                }.padding(.horizontal,8)
                
                
                ScrollView(.horizontal, showsIndicators: false){
                    
                    HStack{
                        Spacer()
                        ForEach(allWatchingTopAnime) { anime in
                            
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
                                } .id(UUID())
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
        allWatchingTopAnime = []
        guard let url = URL(string: "\(DataBaseViewModel.sharedDataBaseVM.Dominio)\(DataBaseViewModel.sharedDataBaseVM.getTopAnimeByWatchingStatus)campo=\(HelpersFunctions.animeWatchingOptions.watching.rawValue.lowercased())") else {
                return
            }
            print(url)
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
                              
                             
                              allWatchingTopAnime.append(anime ?? .init())
                              
                          }
                      
                      
                      
                  } catch {
                      print("Error decoding JSON: \(error)")
                  }
              }
          }.resume()
      }
    }


#Preview {
    AnimeTopWatchingView()
}
