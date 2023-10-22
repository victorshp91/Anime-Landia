//
//  AnimeCategoriesButtonsView.swift
//  AnimeTracker Pro
//
//  Created by Victor Saint Hilaire on 10/18/23.
//

import SwiftUI

struct AnimeCategoriesButtonsView: View {
    @State private var categories: [ButtonsGenre] = []
    @State private var isLoading = true // Controla si se muestra el indicador de carga
    var body: some View {
        VStack{
            ScrollView(.vertical, showsIndicators: false) {
                if !categories.isEmpty {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 200))], spacing: 20){
                        ForEach(categories, id: \.mal_id) { category in
                            NavigationLink(destination: AnimeByCategoryView(category: category)) {
                                HStack{
                                    Text(category.name ?? "N/A")
                                    Spacer()
                                    Text("\(category.count ?? 0)")
                                        .padding(10)
                                        .background(.black)
                                        .clipShape(RoundedRectangle(cornerRadius: 5))
                                }.frame(maxWidth: .infinity)
                                .padding(10)
                                .background(Color("barColor"))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding([.top, .horizontal])
                            }
                            
                        }
                        
                    }.frame(maxWidth: .infinity)
                } else {
                    
                    CustomLoadingView().padding() // Muestra el indicador de carga personalizado
                    
                    Spacer()
                    
                }
                
            }.frame(maxWidth: .infinity)
        }.onAppear {
            fetchData()
        }
        .navigationTitle("Anime Genres")
        .background(Color("background"))
        .frame(maxHeight: .infinity)
        .foregroundStyle(.white)
        .toolbarBackground(
            Color("barColor"),
            for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        }

    func fetchData() {
        guard let url = URL(string: "https://api.jikan.moe/v4/genres/anime") else {
            return
        }
        
        var retryCount = 0
        let maxRetries = 3
        let retryInterval = 2.0

        func performFetch() {
            URLSession.shared.dataTask(with: url) { data, response, error in
                DispatchQueue.main.async {
                    withAnimation {
                        self.isLoading = false
                    }
                }
                
                if let data = data {
                    do {
                        let genreData = try JSONDecoder().decode(GenreData.self, from: data)
                        self.categories = genreData.data
                    } catch {
                        print("Decoding error: \(error)")
                        retryNeeded()
                    }
                } else if let error = error {
                    print("Network error: \(error)")
                    retryNeeded()
                }
            }.resume()
        }

        func retryNeeded() {
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

        // Iniciar la primera solicitud
        performFetch()
    }


    }


#Preview {
    AnimeCategoriesButtonsView()
}
