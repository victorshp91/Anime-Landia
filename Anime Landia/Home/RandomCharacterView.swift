//
//  RandomCharacterView.swift
//  Anime Landia
//
//  Created by Victor Saint Hilaire on 10/1/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct RandomCharacterView: View {
    
    @State private var randomCharacter: CharacterStruct.AnimeCharacter?
    @State private var hasLoadedData = false
    
    var body: some View {
        VStack(alignment: .leading){
            
            if let data = randomCharacter{
                
                VStack(alignment: .leading) {
                            Text("RANDOM CHARACTER")
                            .bold()
                            .font(.callout)
                            HStack(alignment: .top, spacing: 10) {
                                WebImage(url: URL(string: data.images?.jpg.image_url ?? ""))
                                    .resizable()
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .frame(width: 150, height: 230)
                                    .scaledToFill()
                                    .shadow(radius: 5)
                                
                                VStack(alignment: .leading, spacing: 10) {
                                    Text(data.name ?? "N/A")
                                        .font(.title)
                                        .bold()
                                        .lineLimit(2)
                                    HStack {
                                       
                                        Text(String(data.about ?? "N/A"))
                                            .bold()
                                            .font(.caption)
                    
                                            .lineLimit(7)
                                        Spacer()
                                    }
                                    .font(.title)
                                    
                                        
                                    
                                    Spacer()
                                    HStack{
                                        Spacer()
                                        NavigationLink(destination: CharacterDetailsView(character: data)) {
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
                        .background(Color.cyan)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                
                
            } else {
               // Text("Cargando...")
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
        
        guard let url = URL(string: "https://api.jikan.moe/v4/random/characters") else {
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode(CharacterStruct.OnlyCharacterData.self, from: data)
                    DispatchQueue.main.async {
                        self.randomCharacter = decodedData.data
                        
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
    RandomCharacterView()
}
