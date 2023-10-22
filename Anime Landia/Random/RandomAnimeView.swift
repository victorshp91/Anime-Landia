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
                        .background(Color("accountNavColor"))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                
                
            } else {
                CustomLoadingView().padding() // Muestra el indicador de carga personalizado
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

        var retryCount = 0
        let maxRetries = 3 // Número máximo de intentos de retransmisión
        let retryInterval = 3.0 // Tiempo de espera antes de reintentar (en segundos)

        func retryIfNeeded() {
            retryCount += 1
            if retryCount < maxRetries {
                // Si no hemos alcanzado el número máximo de reintentos, esperamos y volvemos a intentar
                DispatchQueue.global().asyncAfter(deadline: .now() + retryInterval) {
                    print("Retrying (attempt \(retryCount))...")
                    performFetch()
                }
            } else {
                print("Max retries reached. Unable to fetch data.")
            }
        }

        func performFetch() {
            AnimeVM.sharedAnimeVM.fetchData(from: url, resultType: OnlyAnimeData.self) { result in
                switch result {
                case .success(let decodedData):
                    self.randomAnime = decodedData.data
                case .failure(let error):
                    print("Error al cargar los datos: \(error)")
                    retryIfNeeded()
                }
            }
        }

        // Iniciar la primera solicitud
        performFetch()
    }


}

#Preview {
    RandomAnimeView()
}
