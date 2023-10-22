//
//  AnimeTopCompletedView.swift
//  AnimeTracker Pro
//
//  Created by Victor Saint Hilaire on 10/17/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct AnimeTopCompletedView: View {

    @State private var allCompletedAnimes: [Anime] = []
    var body: some View {
        
            VStack(alignment: .leading){
                if !allCompletedAnimes.isEmpty {
                    VStack(alignment: .leading){
                        HStack{
                            Text("Completed")
                                
                            Image(systemName: AnimeWatchingButton(animeId: 0, selectedOption: .completed, changeOptionImageSize: 20).icoImage)
                                .font(.title2)
                                .foregroundStyle(AnimeWatchingButton(animeId: 0, selectedOption: .completed, changeOptionImageSize: 20).iconColor)
                        }.font(.title2)
                            
                            .bold()
                       
                     
                        
                            Text("Top animes the users have completed")
                                .font(.caption)
                         
                        
                        
                    }.padding(.horizontal,8)
                    
                    
                    ScrollView(.horizontal, showsIndicators: false){
                        
                        HStack{
                            Spacer()
                            ForEach(allCompletedAnimes, id: \.id) { anime in
                                
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
                                    }
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
                if allCompletedAnimes.isEmpty {
                    getCompletedStatus()
                }
                
            })
        }
        
    func getCompletedStatus() {
        allCompletedAnimes = []

        guard let url = URL(string: "\(DataBaseViewModel.sharedDataBaseVM.Dominio)\(DataBaseViewModel.sharedDataBaseVM.getTopAnimeByWatchingStatus)campo=\(HelpersFunctions.animeWatchingOptions.completed.rawValue.lowercased())") else {
            return
        }

        var retryCount = 0
        let maxRetries = 3
        let retryInterval = 3.0

        func retryIfNeeded() {
            retryCount += 1
            if retryCount < maxRetries {
                DispatchQueue.global().asyncAfter(deadline: .now() + retryInterval) {
                    print("Retrying (attempt \(retryCount))...")
                    performFetch()
                }
            } else {
                print("Max retries reached. Unable to fetch data.")
            }
        }

        func performFetch() {
            URLSession.shared.dataTask(with: url) { data, _, error in
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let decodedData = try decoder.decode([AnimeWatchingStatusTotals].self, from: data)

                        let group = DispatchGroup()

                        for anime in decodedData {
                            if let idAnime = anime.id_anime {
                                group.enter()

                                fetchDetails(for: idAnime) {
                                    group.leave()
                                }
                            }
                        }

                        group.notify(queue: .main) {
                            // All fetch requests have completed
                            // You can process the data here

                            // Example: Print the number of completed animes collected
                            print("Number of completed animes collected: \(allCompletedAnimes.count)")

                            // Here, you can perform any other necessary processing
                        }
                    } catch {
                        print("Error de decodificación: \(error)")
                        retryIfNeeded()
                    }
                } else if let error = error {
                    print("Error de solicitud: \(error)")
                    retryIfNeeded()
                }
            }.resume()
        }

        func fetchDetails(for animeId: Int, completion: @escaping () -> Void) {
            guard let url = URL(string: "https://api.jikan.moe/v4/anime/\(animeId)") else {
                return
            }

            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        let animeResponse = try JSONDecoder().decode(OnlyAnimeData.self, from: data)
                        let anime = animeResponse.data
                        DispatchQueue.main.async {
                            allCompletedAnimes.append(anime ?? .init())
                            completion() // Call the completion handler
                        }
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                }
            }.resume()
        }

        // Start the initial fetch
        performFetch()
    }


}

#Preview {
    AnimeTopCompletedView()
}
