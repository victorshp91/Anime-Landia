//
//  SignInView.swift
//  Anime Landia
//
//  Created by Victor Saint Hilaire on 10/7/23.
//

import SwiftUI

struct SignInView: View {
   
    @State private var email = ""
        @State private var password = ""
    @State private var sucess = false
    @State private var error = false
    @Binding var isLoginPresented: Bool
        var body: some View {
            VStack {
                Text("Login")
                    .font(.largeTitle)
                    .padding(.bottom, 20)
                if error {
                    // Agregar una vista de texto para mostrar el mensaje de error
                    Text("Please verify your email or password.")
                        .foregroundColor(.red) // Puedes ajustar el color del texto según tu preferencia
                        .padding(.top, 10)
                }
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .autocapitalization(.none)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                Button(action: {
                    // Obtener el usuario con éxito
                    AccountVm.sharedUserVM.getUserInformation(email: email, password: password, completion: { usuario in
                        DispatchQueue.main.async { // Asegurarse de estar en el hilo principal
                            if let usuario = usuario {
                                // Guardar el usuario en UserDefaults
                                do {
                                    let encoder = JSONEncoder()
                                    let encodedData = try encoder.encode(usuario)
                                    UserDefaults.standard.set(encodedData, forKey: "userData")
                                    
                                    // Cerrar la vista de inicio de sesión
                                    isLoginPresented = false
                                } catch {
                                    print("Error al codificar y guardar el usuario: \(error)")
                                }
                            } else {
                                // Ocurrió un error o no se encontró el usuario
                                print("No se pudo obtener el usuario.")
                                withAnimation {
                                    error = true
                                }
                            }
                        }
                    })
                }) {
                    Text("Log In")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 40)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
                .padding(.top, 20)
                NavigationLink(destination: SignUpView(isLoginPresented: $isLoginPresented)) {
                    Text("Sign Up") // Cambié el texto a "Sign Up" en inglés
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 40)
                        .foregroundColor(.white)
                        .background(Color.green) // Puedes cambiar el color de fondo según tu preferencia
                        .cornerRadius(8)
                        .padding(.horizontal)
                    
                        .padding(.top, 10) // Agregué un pequeño espacio entre los botones
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.gray.opacity(0.1))
            
          
        }
    }


#Preview {
    SignInView(isLoginPresented: Binding.constant(false))
}
