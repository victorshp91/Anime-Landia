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
    @Binding var isLoginPresented: Bool
        var body: some View {
            VStack {
                Text("Login")
                    .font(.largeTitle)
                    .padding(.bottom, 20)
                
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .autocapitalization(.none)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                Button(action: {
                    AccountVm.sharedUserVM.getUserInformation(email: email, password: password, completion: { usuario in
                        DispatchQueue.main.async { // Asegurarse de estar en el hilo principal
                            if usuario != nil {
                                isLoginPresented = false
                            } else {
                                // Ocurrió un error o no se encontró el usuario
                                print("No se pudo obtener el usuario.")
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
