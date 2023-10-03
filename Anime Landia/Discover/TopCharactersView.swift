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
                    .bold()
                ScrollView(.horizontal, showsIndicators: false){
                    
                    LazyHStack{
                        ForEach(data) { character in
                            NavigationLink(destination: CharacterDetailsView(character: character)) {
                                VStack(alignment: .leading){
                                    WebImage(url: URL(string: character.images?.jpg.image_url ?? "NO DATA"))
                                        .resizable()
                                        .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                                        .frame(maxWidth: 150, maxHeight: 200)
                                        .scaledToFit()
                                        .shadow(radius: 3)
                                    
                                    
                                    
                                    Text("\(character.name ?? "NO DATA")")
                                        .font(.caption)
                                    Spacer()
                                }.frame(maxWidth: 150)
                            }
                        }
                    }
                    
                }
            }else {
                Text("Cargando datos...")
                
            }
            
            Spacer()
            
        }.foregroundStyle(.black)
        .onAppear(perform: loadData)
                .navigationTitle("Discover")
    }

    func loadData() {
        guard let url = URL(string: "https://api.jikan.moe/v4/top/characters?limit=10") else {
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode(CharacterStruct.CharacterData.self, from: data)
                    DispatchQueue.main.async {
                        self.characterData = decodedData.data
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
    TopCharactersView()
}