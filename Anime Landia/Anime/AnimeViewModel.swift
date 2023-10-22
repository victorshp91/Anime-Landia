//
//  AnimeViewModel.swift
//  Anime Landia
//
//  Created by Victor Saint Hilaire on 10/9/23.
//

import Foundation
import Observation
import SwiftUI

@Observable
class AnimeVM {
    
    static let sharedAnimeVM = AnimeVM()
    
    enum orderBy: String,CaseIterable, Identifiable {
        
        case title = "title"
        case start_date = "start_date"
        case end_date = "end_date"
        case episodes = "episodes"
        case popularity = "popularity"
        var id: String {self.rawValue}
    }
    
    
   
    func fetchRatingsForAnime(animeId: Int, isAverage: Bool, page: String, completion: @escaping (RatingResponse) -> Void) {
          
              // Define la URL del script PHP que obtiene las calificaciones para un anime específico
          if let url = URL(string: "\(DataBaseViewModel.sharedDataBaseVM.Dominio)\(DataBaseViewModel.sharedDataBaseVM.getAnimeRating)anime_id=\(animeId)&id_usuario=\(AccountVm.sharedUserVM.userActual.first?.id ?? "0")&calculate_average=\(isAverage)&page=\(page)") {
              
            
                  URLSession.shared.dataTask(with: url) { data, response, error in
                      if let data = data {
                          do {
                              // Decodifica los datos JSON en un array de calificaciones (Rating)
                              
                              let ratings = try JSONDecoder().decode(RatingResponse.self, from: data)
                              // Llama a la clausura de finalización con los datos
                              print(ratings)
                              completion(ratings)
                          } catch {
                              print("Error al decodificar los datos: \(error)")
                          }
                      }
                  }.resume()
              }
          }
    
    func fetchRatingsFeed(isAverage: Bool, page: String, completion: @escaping (RatingResponse) -> Void) {
        // No es necesario especificar anime_id o id_usuario para un feed de calificaciones

        guard let url = URL(string: "\(DataBaseViewModel.sharedDataBaseVM.Dominio)\(DataBaseViewModel.sharedDataBaseVM.getRatingFeed)?calculate_average=\(isAverage)&page=\(page)") else {
            print("URL inválido")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error al obtener los datos: \(error)")
                return
            }

            guard let data = data else {
                print("No se recibieron datos.")
                return
            }

            do {
                let ratings = try JSONDecoder().decode(RatingResponse.self, from: data)
                completion(ratings)
            } catch {
                print("Error al decodificar JSON: \(error)")
            }
        }.resume()
    }


    
    func fetchData<T: Decodable>(from url: URL, resultType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode(resultType, from: data)
                    DispatchQueue.main.async {
                        completion(.success(decodedData))
                    }
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // MENU PARA QUE EL USUARIO ORDENE LA BUSQUEDA DE ANIME COMO DESEE
    struct OrderAnimeByMenuView: View {
        
        @Binding var orderBy: String
        @Binding var sortBy: String
        
        let action: () -> Void // Define a closure as a parameter
        var body: some View {
            Menu {
                Section(header: Text("Order By")) {
                    ForEach(AnimeVM.orderBy.allCases) { option in
                        Button(action: {
                            orderBy = option.rawValue.lowercased()
                            action()
                        }) {
                            HStack {
                                switch option {
                                case .end_date:
                                    Text("End Date")
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
                        sortBy = "asc"
                        action()
                    }) {
                        HStack{
                            Text("Ascending")
                            if sortBy == "asc" {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.green)
                            }
                        }
                    }
                    
                    Button(action: {
                        sortBy = "desc"
                        action()
                    }) {
                        HStack{
                            Text("Descending")
                            if sortBy == "desc" {
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
    }

}
