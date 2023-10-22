//
//  TopCharactersView.swift
//  Anime Landia
//
//  Created by Victor Saint Hilaire on 9/30/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct TopCharactersView: View {
    
    @State private var characterData: [CharacterStruct.AnimeCharacter]?
    
    var body: some View {
        
        VStack(alignment: .leading) {
            if let data = characterData {
                Text("Top 10 Characters")
                    .font(.title2)
                .padding(.horizontal,8)
                .bold()
                ScrollView(.horizontal, showsIndicators: false){
                    
                    LazyHStack{
                        Spacer()
                        ForEach(data) { character in
                            NavigationLink(destination: CharacterDetailsView(character: character)) {
                                VStack(alignment: .leading){
                                    WebImage(url: URL(string: character.images?.jpg.image_url ?? "NO DATA"))
                                        .resizable()
                                        .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                                        .frame(minWidth: 150, minHeight: 200)
                                        .scaledToFit()
                                        .shadow(radius: 3)
                                    
                                    
                                    
                                    Text("\(character.name ?? "NO DATA")")
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
                CustomLoadingView().padding() // Muestra el indicador de carga personalizado
                
            }
            
            Spacer()
            
        }
        .onAppear(perform: loadData)
             //   .navigationTitle("Discover")
    }

    func loadData() {
        guard let url = URL(string: "https://api.jikan.moe/v4/top/characters?limit=10") else {
            return
        }

        var retryCount = 0
        let maxRetries = 3 // Número máximo de intentos de retransmisión
        let retryInterval = 2.0 // Tiempo de espera antes de reintentar (en segundos)

        func performFetch() {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        let decodedData = try JSONDecoder().decode(CharacterStruct.CharacterData.self, from: data)

                        DispatchQueue.main.async {
                            self.characterData = decodedData.data
                        }
                    } catch {
                        print("Error al decodificar los datos: \(error)")
                        retryIfNeeded()
                    }
                } else if let error = error {
                    print("Error al cargar los datos: \(error)")
                    retryIfNeeded()
                }
            }.resume()
        }

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

        // Iniciar la primera solicitud
        performFetch()
    }
}

#Preview {
    TopCharactersView()
}
