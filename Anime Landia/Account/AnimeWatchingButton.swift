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
    @State var beforeSelectOption = HelpersFunctions.animeWatchingOptions.none
    @State  var iconImage: Image = Image(systemName: "")
    @State private var animate = false
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
                    if !AccountVm.sharedUserVM.userActual.isEmpty {
                        Button(action: {
                            beforeSelectOption = selectedOption
                            selectedOption = .watching
                            guardarWatchingStatus()
                            animate.toggle()
                        }) {
                            Label("Watching", systemImage: "eye.circle.fill")
                                .foregroundStyle(.blue)
                        }
                        
                        Button(action: {
                            beforeSelectOption = selectedOption
                            selectedOption = .completed
                            guardarWatchingStatus()
                            animate.toggle()
                            
                        }) {
                            Label("Completed", systemImage: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                        }
                        
                        Button(action: {
                            beforeSelectOption = selectedOption
                            selectedOption = .hold
                            guardarWatchingStatus()
                            animate.toggle()
                        }) {
                            Label("On Hold", systemImage: "pause.circle.fill")
                            
                        }
                        
                        if selectedOption != .none{
                            Button(action: {
                                beforeSelectOption = selectedOption
                                selectedOption = .none
                                guardarWatchingStatus()
                                animate.toggle()
                                
                            }) {
                                Label("None", systemImage: "minus.circle.fill")
                                
                            }
                        }
                    }  else {
                        Text("SIGN IN")
                     }
                    
                } label: {
                    Circle()
                        .foregroundColor(Color.black.opacity(0.8))
                        .frame(width: changeOptionImageSize+10, height: changeOptionImageSize+10)
                        .overlay(
                            Image(systemName: icoImage)
                                .resizable()
                                .font(.title2)
                                
                                                    .symbolEffect(.bounce.down, value: animate)
                                .frame(width: changeOptionImageSize, height: changeOptionImageSize)
                                .foregroundColor(iconColor)
                            
                        ).padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 5))

                  
                }
            }
     
        }.ignoresSafeArea()
            .onAppear(perform: {
                print("MMG")
                obtenerWatchingStatus()
                // solo ponenemos la opcion si esta con datos en la bae de datos
        
                
            })
        
    }
    
    func obtenerWatchingStatus() {
        
        if let url = URL(string: "\(DataBaseViewModel.sharedDataBaseVM.Dominio)\(DataBaseViewModel.sharedDataBaseVM.getAnimeWatchingStatus)id_usuario=\(AccountVm.sharedUserVM.userActual.first?.id ?? "")&id_anime=\(animeId)") {
            print(url)
                URLSession.shared.dataTask(with: url) { data, response, error in
                    if let data = data {
                        let decoder = JSONDecoder()
                        do {
                            let decodedData = try decoder.decode([Favorito].self, from: data)

                            DispatchQueue.main.async {
                                self.watching = decodedData
                                // pomemos de el estado del watching obtenido de la base de datos
                                print(watching)
                                selectedOption = HelpersFunctions.animeWatchingOptions(rawValue: (self.watching.first?.watching ?? "")!) ?? .none
                                beforeSelectOption = HelpersFunctions.animeWatchingOptions(rawValue: (self.watching.first?.watching ?? "")!) ?? .none
                                print("MMG")
                                print(selectedOption)
                            
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
        let urlString = "\(DataBaseViewModel.sharedDataBaseVM.Dominio)\(DataBaseViewModel.sharedDataBaseVM.saveWatchingStatusOrFavorite)id_usuario=\(AccountVm.sharedUserVM.userActual.first?.id ?? "")&id_anime=\(animeId)&watching=\(selectedOption.rawValue.lowercased())"
            
            
            if let url = URL(string: urlString) {
                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                    if let error = error {
                        print("Error en la solicitud HTTP: \(error)")
                    } else if let data = data {
                        if let responseString = String(data: data, encoding: .utf8) {
                            print(data)
                            print("Respuesta del servidor: \(responseString)")
                            
                            // Llama a la función para aumentar o disminuir el valor de favorito en la tabla que lleva lo cuenta de totales de todos los usuarios
                            
                            AccountVm.sharedUserVM.updateWatchingStatusNumbers(idAnime: animeId, campo: selectedOption.rawValue.lowercased(), accion: "aumentar") { result in
                                switch result {
                                case .success(let message):
                                    print(message)
                                    
                                    // Luego de aumentar, disminuye la selección anterior del usuario
                                    AccountVm.sharedUserVM.updateWatchingStatusNumbers(idAnime: animeId, campo: beforeSelectOption.rawValue.lowercased(), accion: "disminuir") { result in
                                        switch result {
                                        case .success(let message):
                                            print(message)
                                        case .failure(let error):
                                            print(error.localizedDescription)
                                        }
                                    }
                                    
                                case .failure(let error):
                                    print(error.localizedDescription)
                                }
                            }

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
