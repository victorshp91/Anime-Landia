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
                            
                            Text("\(currentPage) of \(paginationData.last_visible_page)")
                            
                            HStack{
                                
                                Button(action: {
                                    currentPage -= 1
                                    
                                    loadAnimes()
                                    
                                }){
                                    Image(systemName: "arrow.left.circle.fill")
                                }.disabled(currentPage == 1)
                                
                                Button(action: {
                                    currentPage += 1
                                    
                                    loadAnimes()
                                    
                                }){
                                    Image(systemName: "arrow.right.circle.fill")
                                }.disabled(!paginationData.has_next_page)
                                
                            }
                            
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
                            
                        }else {
                            
                            CustomLoadingView().padding() // Muestra el indicador de carga personalizado
                        }
                    }
                    
                    
                }
            }.onAppear(perform: {
                loadAnimes()
            })
                .navigationTitle("\(category.name ?? "N/A")")
                .background(Color("background"))
                .frame(maxHeight: .infinity)
                .foregroundStyle(.white)
                .toolbarBackground(
                    Color("barColor"),
                    for: .navigationBar)
                .toolbarColorScheme(.dark, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        OrderByMenu()
                        
                    }
                }
        }
    
    func OrderByMenu() -> some View {
        Menu {
            Section(header: Text("Order By")) {
                ForEach(AnimeVM.orderBy.allCases) { option in
                    Button(action: {
                        orderBy = option.rawValue.lowercased()
                        loadAnimes()
                    }) {
                        HStack {
                            switch option {
                            case .end_date:
                                Text("End Date")
                            case .mal_id:
                                Text("ID")
                            case .title:
                                Text("Title")
                            case .start_date:
                                Text("Start Date")
                            case .episodes:
                                Text("Total Episodes")
                            case .popularity:
                                Text("Pupularity")
                            }
                            
                            if option.rawValue.lowercased() == orderBy.lowercased() {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.green)
                            }
                        }
                    }
                }
            }
            
            Section(header: Text("Sort")) {
                
                Button(action: {
                    sort = "asc"
                    loadAnimes()
                }) {
                    HStack{
                    Text("Ascending")
                        if sort == "asc" {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                        }
                }
                }
                
                Button(action: {
                    sort = "desc"
                    loadAnimes()
                }) {
                    HStack{
                    Text("Descending")
                        if sort == "desc" {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                        }
                }
                }
           
            }
        } label: {
            Image(systemName: "line.3.horizontal.decrease.circle.fill")
                .font(.title2)
        }
    }
    
    func loadAnimes() {
    
        // si el type de anime es all entonces el link es sin type
        guard let url = URL(string: "https://api.jikan.moe/v4/anime?genres=\(category.mal_id)&page=\(currentPage)&order_by=\(orderBy)&sort=\(sort)&sfw=true") else {
            return
        }
        print(url)
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            ratingAverage = [:]
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode(AnimeData.self, from: data)
                    
                    DispatchQueue.main.async {
                        self.animeData = decodedData.data
                        self.pagination = decodedData.pagination
                        
                        // AGREGO EL RATING DE CADA ANIME POR EL ID EN EL ARREGLO DECLARADO ARRIBA QUE ES UN DICCIONARIO QUE CONTIENE EL ID DEL ANIME Y EL RATING
                        
                        if let animes = animeData{
                            for anime in animes{
                                AnimeVM.sharedAnimeVM.fetchRatingsForAnime(animeId: anime.mal_id ?? 0, isAverage: true, page: "1", completion: { rating in
                                    if let average = rating.average{
                                        ratingAverage["\(anime.mal_id ?? 0)"] = average
                                    }
                                    
                                    
                                })
                            }
                        }
                        
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
    AnimeByCategoryView(category: ButtonsGenre(mal_id: 0, name: "", url: ""))
}
