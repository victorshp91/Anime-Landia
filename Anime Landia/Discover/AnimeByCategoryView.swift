//
//  AnimeByCategoryView.swift
//  AnimeTracker Pro
//
//  Created by Victor Saint Hilaire on 10/18/23.
//

import SwiftUI

struct AnimeByCategoryView: View {
    var category: ButtonsGenre
   
    @State private var animeData: [Anime]?
    @State private var pagination: Pagination?
    @State private var ratingAverage = [String:Double]()
    @State private var orderBy = "title"
    @State private var sort = "asc"
    @State var currentPage = 1
    
        var body: some View {
            
            VStack{
                ScrollView{
                    
                    if let paginationData = pagination {
                        HStack{
                            Button(action: {
                                currentPage -= 1
                                
                                loadAnimes()
                                
                            }){
                                Image(systemName: "arrow.left.circle.fill")
                            }.disabled(currentPage == 1)
                            Spacer()
                            Text("\(currentPage) of \(paginationData.last_visible_page)")
                            Spacer()
                            Button(action: {
                                currentPage += 1
                                
                                loadAnimes()
                                
                            }){
                                Image(systemName: "arrow.right.circle.fill")
                            }.disabled(!paginationData.has_next_page)
                            
                        }.font(.title)
                            .padding(10)
                            .frame(maxWidth: .infinity)
                            .background(Color("barColor"))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding([.top, .horizontal])
                        
                            .foregroundStyle(.white)
                        
                        
                        if let animes = animeData {
                            
                            SearchView().animeListView(animes: animes, ratingAverage: ratingAverage )
                                .padding(.horizontal)
                            
                        }
                    } else {
                        CustomLoadingView().padding() // Muestra el indicador de carga personalizado
                    }
                    
                    
                }
            }.onAppear(perform: {
                loadAnimes()
            }).frame(maxWidth: .infinity, maxHeight: .infinity)
                .navigationTitle("\(category.name ?? "N/A")")
                .background(Color("background"))
                
                .foregroundStyle(.white)
                .toolbarBackground(
                    Color("barColor"),
                    for: .navigationBar)
                .toolbarColorScheme(.dark, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        AnimeVM.OrderAnimeByMenuView.init(orderBy: $orderBy, sortBy: $sort, action: {
                            loadAnimes()
                        })
                        
                    }
                }
        }
    
    func loadAnimes() {
        // Construir la URL de la API
        guard let url = makeAPIURL() else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                ratingAverage = [:] // Reiniciar el diccionario de ratings
                
                if let data = data {
                    do {
                        let decodedData = try JSONDecoder().decode(AnimeData.self, from: data)
                        updateUI(with: decodedData)
                    } catch {
                        print("Error al decodificar los datos: \(error)")
                    }
                } else if let error = error {
                    print("Error al cargar los datos: \(error)")
                }
            }
        }.resume()
    }

    func makeAPIURL() -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.jikan.moe"
        components.path = "/v4/anime"
        
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "genres", value: "\(category.mal_id)"))
        queryItems.append(URLQueryItem(name: "page", value: "\(currentPage)"))
        queryItems.append(URLQueryItem(name: "order_by", value: orderBy))
        queryItems.append(URLQueryItem(name: "sort", value: sort))
        queryItems.append(URLQueryItem(name: "sfw", value: "true"))
        
        components.queryItems = queryItems
        
        return components.url
    }

    func updateUI(with decodedData: AnimeData) {
        self.animeData = decodedData.data
        self.pagination = decodedData.pagination
        
        if let animes = animeData {
            for anime in animes {
                AnimeVM.sharedAnimeVM.fetchRatingsForAnime(animeId: anime.mal_id ?? 0, isAverage: true, page: "1") { rating in
                    if let average = rating.average {
                        ratingAverage["\(anime.mal_id ?? 0)"] = average
                    }
                }
            }
        }
    }

}

#Preview {
    AnimeByCategoryView(category: ButtonsGenre(mal_id: 0, name: "", url: ""))
}
