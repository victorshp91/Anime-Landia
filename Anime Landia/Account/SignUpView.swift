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
        // @State para almacenar el mensaje del API
        @State private var apiMessage = ""
        @State private var showApiMessage = false
        @State private var isSuccess = false
        @State private var showLoading = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
        VStack {
            
            Text("Sign Up")
                .font(.largeTitle)
                .padding(.bottom, 20)
            if showLoading {
                HelpersFunctions().loadingView()
            }
            if showApiMessage {
                
                Text(apiMessage)
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding()
                    .background(isSuccess ? .green : .red)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .opacity(apiMessage.isEmpty ? 0 : 1) // Animación de fade-in
                
            }
            TextField("Email", text: $email)
                
                .padding(15)
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
                .padding(.horizontal)
                .autocapitalization(.none)
                .onChange(of: email) {
                    onTextFieldChange()
                }
            
            
            TextField("Username", text: $user)
                
                .padding(15)
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
                .padding(.horizontal)
                .autocapitalization(.none)
                .onChange(of: user) {
                    onTextFieldChange()
                }
            
            SecureField("Password", text: $password)
                
                .padding(15)
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
                .padding(.horizontal)
                .onChange(of: password) {
                    onTextFieldChange()
                }
            
            ZStack(alignment: .trailing) {
                if isPasswordMatchError {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.red.opacity(0.3))
                        .frame(height: 40)
                }
                SecureField("Confirm Password", text: $confirmPassword)
                    
                    .padding(15)
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
                    .padding(.horizontal)
                    .onChange(of: confirmPassword) {
                        onTextFieldChange()
                    }
                
                
                
            }
            
            Button(action: {
                if password == confirmPassword {
                    withAnimation {
                        showLoading = true
                    }
                    // Hacer la solicitud al API
                    guard let url = URL(string: "\(DataBaseViewModel.sharedDataBaseVM.Dominio)\(DataBaseViewModel.sharedDataBaseVM.saveUser)usuario=\(user)&email=\(email)&contrasena=\(password)") else {
                        return
                    }
                    
                    URLSession.shared.dataTask(with: url) { data, response, error in
                        if let data = data {
                            do {
                                // Decodificar la respuesta JSON
                                let response = try JSONDecoder().decode(APIResponse.self, from: data)
                                withAnimation {
                                    showApiMessage = true
                                    showLoading = false
                                }
                                apiMessage = response.message
                                
                                
                                if response.success {
                                    isSuccess = true
                                    // Obtener el usuario con éxito
                                    AccountVm.sharedUserVM.getUserInformation(email: email, password: password, completion: { usuario in
                                        DispatchQueue.main.async { // Asegurarse de estar en el hilo principal
                                            if let usuario = usuario {
                                                // Guardar el usuario en UserDefaults
                                                do {
                                                    let encoder = JSONEncoder()
                                                    let encodedData = try encoder.encode(usuario)
                                                    UserDefaults.standard.set(encodedData, forKey: "userData")
                                                    
                                                    // Cerrar la vista
                                                    isLoginPresented = false
                                                } catch {
                                                    print("Error al codificar y guardar el usuario: \(error)")
                                                }
                                            } else {
                                                // Ocurrió un error o no se encontró el usuario
                                                print("No se pudo obtener el usuario.")
                                                
                                            }
                                        }
                                    })
                                    
                                    
                                    
                                }
                            } catch {
                                print(error)
                            }
                        }
                    }.resume()
                    
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
    }
                .padding()
                .navigationBarTitle("", displayMode: .inline) // Ocultar el título de navegación
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("background"))
                
            
        }
    

    
    func onTextFieldChange(){
        
        withAnimation {
            showApiMessage = false
            isPasswordMatchError = false
        }
        
    }
}

#Preview {
    SignUpView(isLoginPresented: Binding.constant(false))
}
