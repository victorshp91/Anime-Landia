//
//  AddNewFriendView.swift
//  AnimeTracker Pro
//
//  Created by Victor Saint Hilaire on 10/14/23.
//

import SwiftUI

struct AddNewFriendView: View {
    @State var searchText = ""
    @State private var usersResult: [Usuario] = []
    @State private var requestSent = false
    var body: some View {
        VStack(alignment:.leading){
            SearchTextField(searchingText: $searchText, onSearch: {
                // Filtrar los usuarios en función del texto de búsqueda
                 
                search()
                
            }, onChange: {
                                
                
            }, by: "user name")
            .padding(.bottom)
            if !usersResult.isEmpty{
                ForEach(usersResult, id: \.id) { user in
                    HStack{
                        Text("@\(user.usuario ?? "N/A")")
                        Spacer()
                        if requestSent {
                            Text("Request Sent")
                                .foregroundStyle(.green)
                        } else {
                            Button(action: {
                                addFriend(user1ID: AccountVm.sharedUserVM.userActual.first?.id ?? "N/A", user2ID: user.id ?? "N/A", whoSentID: AccountVm.sharedUserVM.userActual.first?.id ?? "N/A")
                                withAnimation {
                                    
                                    requestSent = true
                                }
                            }){
                                Text("Add")
                                    .foregroundStyle(.blue)
                            }
                            
                        }
                    }.padding()
                        .frame(maxWidth: .infinity)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .foregroundStyle(.black)
                        // Puedes mostrar otros campos de amigo aquí
                    
                }
            }
            
            Spacer()
        }.padding(.horizontal)
            .navigationTitle("Searching Users")
    }
    
    func search() {
        guard let url = URL(string: "\(DataBaseViewModel.sharedDataBaseVM.Dominio)\(DataBaseViewModel.sharedDataBaseVM.searchUsers)username=\(searchText)") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                do {
                    let users = try JSONDecoder().decode([Usuario].self, from: data)
                    DispatchQueue.main.async {
                        usersResult = users
                    }
                } catch {
                    print("Error de decodificación: \(error)")
                }
            } else if let error = error {
                print("Error de solicitud: \(error)")
            }
        }.resume()
    }
    
    func addFriend(user1ID: String, user2ID: String, whoSentID:String) {
        guard let url = URL(string: "\(DataBaseViewModel.sharedDataBaseVM.Dominio)\(DataBaseViewModel.sharedDataBaseVM.addNewFriend)user_id1=\(user1ID)&user_id2=\(user2ID)&who_sent_id=\(whoSentID)") else {
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
         
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data, let _ = String(data: data, encoding: .utf8) {
                    DispatchQueue.main.async {
                        withAnimation {
                            requestSent = true
                        }
                    }
                } else if let error = error {
                    print("Error: \(error)")
                }
            }.resume()
        }
   





}

#Preview {
    AddNewFriendView()
}
