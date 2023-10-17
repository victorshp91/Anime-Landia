//
//  UserWatchingView.swift
//  Anime Landia
//
//  Created by Victor Saint Hilaire on 10/7/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct UserWatchingView: View {
    @State private var allAnimes: [Anime] = []
    @State private var isLoading = false
    @State private var showNoData = false
    var friend: [Usuario]
    var isFor: HelpersFunctions.animeWatchingOptions
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            // SI VIENE PARA PRESENTAR DEL AMIGO ENTONCES PRESENTA EL USUARIO DEL AMIGO
            if !friend.isEmpty {
                HStack{
                    Text("By @\(friend.first?.usuario ?? "N/A")")
                        .font(.title)
                        .bold()
                        .foregroundStyle(.white)
                    Spacer()
                }.padding(.horizontal)
                    .padding(.top)
            }
            if isLoading {
                HelpersFunctions().loadingView()
            }
            if showNoData {
                HelpersFunctions.NoDataView()
                    .padding()
            }
            if !allAnimes.isEmpty {
                
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
                    ForEach(allAnimes, id: \.id) { item in
                        NavigationLink(destination: AnimeDetailsView(anime: item)) {
                            WebImage(url: URL(string: item.images?.jpg.large_image_url  ?? ""))
                                .resizable()
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .frame(width: 150, height: 230)
                                .scaledToFill()
                                .shadow(radius: 5)
                        }
                    }
                }
                .padding()
            }
            
        }
        .frame(maxWidth: .infinity)
        .onAppear {
            
            obtenerFavoritos()
            
            
            
        }
        //.navigationTitle("\(isFor.rawValue.capitalized)")
        .background(Color("background"))
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                
                Image(systemName: AnimeWatchingButton(animeId: 0, selectedOption: isFor, changeOptionImageSize: 20).icoImage)
                    .font(.title2)
                    .foregroundStyle(AnimeWatchingButton(animeId: 0, selectedOption: isFor, changeOptionImageSize: 20).iconColor)
                
            }
        }
        .navigationTitle(isFor.rawValue.capitalized)
        .toolbarBackground(
            Color("barColor"),
            for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)

     
            
            
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
                        
                        self.allAnimes.append(anime ?? .init())
                        
                    }
                } catch {
                    
                    print("Error decoding JSON: \(error)")
                }
            }
        }.resume()
    }
    
    func obtenerFavoritos() {
        allAnimes = []
        withAnimation {
            isLoading = true
        }
        var userID = ""
        
        if friend.isEmpty {
            // Si el usuario está conectado, asigna el ID del usuario actual
            userID = AccountVm.sharedUserVM.userActual.first?.id ?? ""
        } else {
            // Si el usuario no está conectado, asigna un valor predeterminado o lo que sea necesario
            userID = friend.first?.id ?? "N/A"
        }

       
        if let url = URL(string: "\(DataBaseViewModel.sharedDataBaseVM.Dominio)\(DataBaseViewModel.sharedDataBaseVM.getAnimeWatchingStatus)id_usuario=\(userID)&watching=\(isFor.rawValue.lowercased())"){
            
            print(url)
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let decodedData = try decoder.decode([Favorito].self, from: data)
                        
                        DispatchQueue.main.async {
                            
                    
                            for favorito in decodedData {
                                if let idAnime = favorito.id_anime {
                                    fetch(Id: idAnime)
                                    // pomemos de el estado del watching obtenido de la base de datos
                                }
                            }
                          
                            isLoading = false
                            
                            
                        }
                    } catch {
                        isLoading = false
                        showNoData = true
                        print("Error al decodificar el JSON: \(error)")
                    }
                } else if let error = error {
                    isLoading = false
                    showNoData = true
                    print("Error en la solicitud HTTP: \(error)")
                }
            }.resume()
        }
    }
    
}



#Preview {
    UserWatchingView(friend: .init(), isFor: .none)
}
