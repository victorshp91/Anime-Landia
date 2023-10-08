//
//  Anime_LandiaApp.swift
//  Anime Landia
//
//  Created by Victor Saint Hilaire on 9/30/23.
//

import SwiftUI

@main
struct Anime_LandiaApp: App {
    @State private var showWelcomeScreen = true
    var body: some Scene {
        WindowGroup {
            NavigationView{
                if showWelcomeScreen {
                                WelcomeScreeView()
                                    .onAppear {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                            withAnimation {
                                                showWelcomeScreen = false
                                            }
                                        }
                                    }
                            } else {
                                TabBarMenu() // Tu vista principal
                                    .onAppear(perform: {
                                        // OBTENGO LO DATOS GUARDADO DEL INICIO DE SESION
                                        if let encodedData = UserDefaults.standard.data(forKey: "userData") {
                                            let decoder = JSONDecoder()
                                            
                                            do {
                                                // Decodificar los datos en un objeto Usuario
                                                let usuario = try decoder.decode(Usuario.self, from: encodedData)
                                                
                                                // Utiliza el objeto Usuario para autenticar al usuario automáticamente
                                                // Por ejemplo, puedes establecer una variable de estado de autenticación en tu aplicación
                                                // o realizar cualquier otra lógica de autenticación necesaria
                                                
                                                // Cerrar la vista de inicio de sesión
                                                AccountVm.sharedUserVM.userActual = [usuario]
                                            } catch {
                                                print("Error al decodificar el objeto Usuario: \(error)")
                                            }
                                        }

                                    })
                            }
                
                    
                
            }
        }
    }
}
