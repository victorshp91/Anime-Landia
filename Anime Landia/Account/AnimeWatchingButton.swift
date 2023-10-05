//
//  AnimeWatchingButton.swift
//  Anime Landia
//
//  Created by Victor Saint Hilaire on 10/3/23.
//

import SwiftUI

struct AnimeWatchingButton: View {
    var animeId: Int
    @State var watching: [Favorito] = []
    @State var selectedOption = HelpersFunctions.animeWatchingOptions.none
    
    @State  var iconImage: Image = Image(systemName: "")
    var changeOptionImageSize: CGFloat
    
      var iconColor: Color {
        switch selectedOption {
        case .watching:
            return Color.blue
        case .completed:
            return Color.green
        case .hold:
            return Color.gray
        case .none:
            return .cyan
        }
    }
    
     var icoImage: String {
        switch selectedOption {
        case .watching:
            return  "eye.circle.fill"
        case .completed:
            return "checkmark.circle.fill"
        case .hold:
            return "pause.circle.fill"
        case .none:
            return "plus.circle.fill"
        }
        
        
    }
    
    var body: some View {
        HStack{
            ZStack {
                Menu {
                    Button(action: {
                        selectedOption = .watching
                        guardarWatchingStatus()
                    }) {
                        Label("Watching", systemImage: "eye.circle.fill")
                            .foregroundStyle(.blue)
                    }
                    
                    Button(action: {
                        selectedOption = .completed
                        guardarWatchingStatus()
                        
                    }) {
                        Label("Completed", systemImage: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                    }
                    
                    Button(action: {
                        selectedOption = .hold
                        guardarWatchingStatus()
                    }) {
                        Label("On Hold", systemImage: "pause.circle.fill")
                        
                    }
                    if selectedOption != .none{
                        Button(action: {
                            selectedOption = .none
                            
                        }) {
                            Label("None", systemImage: "minus.circle.fill")
                            
                        }
                    }
                    
                } label: {
                    Circle()
                        .foregroundColor(Color.black.opacity(0.8))
                        .frame(width: changeOptionImageSize+10, height: changeOptionImageSize+10)
                        .overlay(
                            Image(systemName: icoImage)
                                .resizable()
                                .font(.title2)
                                .frame(width: changeOptionImageSize, height: changeOptionImageSize)
                                .foregroundColor(iconColor)
                            
                        ).padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 5))

                  
                }
            }
     
        }.ignoresSafeArea()
            .onAppear(perform: {
                obtenerWatchingStatus()
                // solo ponenemos la opcion si esta con datos en la bae de datos
        
                
            })
        
    }
    
    func obtenerWatchingStatus() {
            if let url = URL(string: "https://rayjewelry.us/api.php?id_usuario=1&id_anime=\(animeId)&favorite=true") {
                URLSession.shared.dataTask(with: url) { data, response, error in
                    if let data = data {
                        let decoder = JSONDecoder()
                        do {
                            let decodedData = try decoder.decode([Favorito].self, from: data)

                            DispatchQueue.main.async {
                                self.watching = decodedData
                                // pomemos de el estado del watching obtenido de la base de datos
                                selectedOption = HelpersFunctions.animeWatchingOptions(rawValue: (self.watching.first?.watching ?? "")!) ?? .none
                            }
                        } catch {
                            print("Error al decodificar el JSON: \(error)")
                        }
                    } else if let error = error {
                        print("Error en la solicitud HTTP: \(error)")
                    }
                }.resume()
            }
        }
    
    func guardarWatchingStatus() {
        let urlString = "https://rayjewelry.us/guardar_favorito_watching.php?id_usuario=\(1)&id_anime=\(animeId)&watching=\(selectedOption.rawValue.lowercased())"
            
            
            if let url = URL(string: urlString) {
                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                    if let error = error {
                        print("Error en la solicitud HTTP: \(error)")
                    } else if let data = data {
                        if let responseString = String(data: data, encoding: .utf8) {
                            print(data)
                            print("Respuesta del servidor: \(responseString)")
                        }
                    }
                }
                task.resume()
            }
        }
    }


#Preview {
    AnimeWatchingButton(animeId: 1, changeOptionImageSize: 20)
}
