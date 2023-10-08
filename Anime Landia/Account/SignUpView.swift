//
//  SignUpView.swift
//  Anime Landia
//
//  Created by Victor Saint Hilaire on 10/7/23.
//

import SwiftUI

struct SignUpView: View {
    @State private var email = ""
        @State private var password = ""
        @State private var confirmPassword = ""
        @State private var user = ""
        @Binding var isLoginPresented: Bool
        @State private var isPasswordMatchError = false
        
        var body: some View {
          
                VStack {
                    Text("Sign Up")
                        .font(.largeTitle)
                        .padding(.bottom, 20)
                    
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .autocapitalization(.none)
                    
                    TextField("Username", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .autocapitalization(.none)
                    
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    SecureField("Confirm Password", text: $confirmPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .background(isPasswordMatchError ? Color.red.opacity(0.3) : Color.clear)
                    
                    Button(action: {
                        if password == confirmPassword {
                            // Las contraseñas coinciden, puedes proceder con el registro
                            print("Registro exitoso. Email: \(email), Password: \(password)")
                            isLoginPresented = false
                        } else {
                            // Las contraseñas no coinciden, muestra un error
                            isPasswordMatchError = true
                        }
                    }) {
                        Text("Sign Up")
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .frame(height: 40)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(8)
                            .padding(.horizontal)
                    }
                    .padding(.top, 20)
                }
                .padding()
                .navigationBarTitle("", displayMode: .inline) // Ocultar el título de navegación
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.gray.opacity(0.1))
                
            
        }
}

#Preview {
    SignUpView(isLoginPresented: Binding.constant(false))
}
