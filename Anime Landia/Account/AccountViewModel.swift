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
    
    func getUserInformation(email: String, password: String, completion: @escaping (Usuario?) -> Void) {
        
        guard let url = URL(string: "https://rayjewelry.us/get_user.php?email=\(email)&contrasena_ingresada=\(password)") else {
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



}
