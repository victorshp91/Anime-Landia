//
//  AccountViewModel.swift
//  Anime Landia
//
//  Created by Victor Saint Hilaire on 10/7/23.
//

import Foundation
import Observation

@Observable class AccountVm {
    
    static let sharedUserVM = AccountVm()
    
    var userActual = [Usuario]()
    
    enum friendStatus: String {
        case accepted = "accepted"
        case pending = "pending"
        case rejected = "rejected"
    }
    
    func getUserInformation(email: String, password: String, completion: @escaping (Usuario?) -> Void) {
        
        guard let url = URL(string: "\(DataBaseViewModel.sharedDataBaseVM.hosting)\(DataBaseViewModel.sharedDataBaseVM.getUser)email=\(email)&contrasena_ingresada=\(password)") else {
            completion(nil)
            return
        }
        
        

        URLSession.shared.dataTask(with: url) { [self] (data, response, error) in
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode([Usuario].self, from: data)
                    DispatchQueue.main.async {
                        completion(decodedData.first)
                        self.userActual = decodedData // Asignación a la propiedad 'userActual'
                    }
                } catch {
                    print("Error al decodificar los datos: \(error)")
                    completion(nil)
                }
            } else if let error = error {
                print("Error al cargar los datos: \(error)")
                completion(nil)
            }
        }.resume()
    }
    
    func updateWatchingStatusNumbers(idAnime: Int, campo: String, accion: String, completion: @escaping (Result<String, Error>) -> Void) {
        // URL de la API PHP en tu servidor
        let apiUrl = "\(DataBaseViewModel.sharedDataBaseVM.hosting)\(DataBaseViewModel.sharedDataBaseVM.changeWatchingStatusNumbers)id_anime=\(idAnime)&campo=\(campo)&accion=\(accion)"
        
        if let url = URL(string: apiUrl) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                } else if let data = data {
                    if let responseString = String(data: data, encoding: .utf8) {
                        completion(.success(responseString))
                    } else {
                        completion(.failure(NSError(domain: "InvalidData", code: 0, userInfo: nil)))
                    }
                }
            }
            task.resume()
        } else {
            completion(.failure(NSError(domain: "InvalidURL", code: 0, userInfo: nil)))
        }
    }



}
