//
//  LogoutConfirmationView.swift
//  Anime Landia
//
//  Created by Victor Saint Hilaire on 10/7/23.
//

import SwiftUI

struct SignOutConfirmationView: View {
    @Binding var isShowingLogoutView: Bool
        
        var body: some View {
            VStack {
                Text("Sign Out")
                    .font(.title)
                    .foregroundColor(.red)
                    .padding(.bottom, 20)
                
                Text("Are you sure you want to sign out?")
                    .font(.body)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                HStack {
                    Button(action: {
                        // Agregar aquí la lógica para cerrar sesión
                        // Por ejemplo, borrar los datos del usuario almacenados en UserDefaults
                        
                        // Cerrar la vista de Logout
                        isShowingLogoutView = false
                        // al cerrar sesion se borra los datos del usuario en memoria
                        AccountVm.sharedUserVM.userActual.removeFirst()
                        // Cuando el usuario cierra sesión, borra los datos guardados en UserDefaults
                        UserDefaults.standard.removeObject(forKey: "userData")
                    }) {
                        Text("Sign Out")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        // Cerrar la vista de Logout
                        isShowingLogoutView = false
                    }) {
                        Text("Cancel")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .padding()
                            .background(Color.clear)
                            .cornerRadius(10)
                    }
                }
                Spacer()
            }
            .padding()
        }
}

#Preview {
    SignOutConfirmationView(isShowingLogoutView: Binding.constant(false))
}
