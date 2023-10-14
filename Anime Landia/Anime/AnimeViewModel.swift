//
//  AnimeViewModel.swift
//  Anime Landia
//
//  Created by Victor Saint Hilaire on 10/9/23.
//

import Foundation
import Observation

@Observable
class AnimeVM {
    
    static let sharedAnimeVM = AnimeVM()
    
    
   
    func fetchRatingsForAnime(animeId: Int, isAverage: Bool, page: String, completion: @escaping (RatingResponse) -> Void) {
        
            // Define la URL del script PHP que obtiene las calificaciones para un anime específico
        if let url = URL(string: "\(DataBaseViewModel.sharedDataBaseVM.Dominio)\(DataBaseViewModel.sharedDataBaseVM.getAnimeRating)anime_id=\(animeId)&id_usuario=\(AccountVm.sharedUserVM.userActual.first?.id ?? "0")&calculate_average=\(isAverage)&page=\(page)") {
            
            print(url)
            print(url)
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

}
