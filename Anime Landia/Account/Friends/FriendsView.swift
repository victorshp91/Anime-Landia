//
//  FriendsView.swift
//  AnimeTracker Pro
//
//  Created by Victor Saint Hilaire on 10/11/23.
//

import SwiftUI

struct FriendsView: View {
    @State var searchText = ""
    @State private var friends: [Usuario] = []
    @State private var filteredUsers: [Usuario] = []
    var friendStatus: AccountVm.friendStatus
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
        VStack(alignment:.leading){
            
            SearchTextField(searchingText: $searchText, onSearch: {
                // Filtrar los usuarios en función del texto de búsqueda
                 
                
                
            }, onChange: {
                // Filtrar los usuarios en función del texto de búsqueda
                filteredUsers = friends.filter { user in
                    if let usuario = user.usuario, !searchText.isEmpty {
                        return usuario.lowercased().contains(searchText.lowercased())
                    } else {
                        return false
                    }
                }
                
                
            }, by: "user name")
            
                ForEach(searchText.isEmpty ? friends:filteredUsers, id: \.id) { friend in
                   FriendListView(friend: friend)
                }
        }.padding(.top)
            Spacer()
        }//.navigationTitle(friendStatus == .accepted ? "Friends":"Friend Requests")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if friendStatus == .accepted {
                        
                        NavigationLink(destination: AddNewFriendView()){
                            Image(systemName: "plus.circle.fill").foregroundColor(.cyan).font(.title2)
                        }
                    }
                    
                }
            }
            .onAppear(perform: {
                getFriends()
            })
            .padding(.horizontal)
            .navigationTitle("Friends")
            .background(Color("background"))
            .toolbarBackground(
                Color("barColor"),
                for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
    }
    
    func getFriends(){
        
        guard let url = URL(string: "\(DataBaseViewModel.sharedDataBaseVM.Dominio)\(DataBaseViewModel.sharedDataBaseVM.getUserFriends)user_id=\(AccountVm.sharedUserVM.userActual.first?.id ?? "")&status=\(friendStatus.rawValue.lowercased())") else {
                       return
                   }

        print(url)
                   URLSession.shared.dataTask(with: url) { data, _, error in
                       if let data = data {
                           do {
                               let decoder = JSONDecoder()
                               let friends = try decoder.decode([Usuario].self, from: data)
                               DispatchQueue.main.async {
                                   self.friends = friends
                               }
                           } catch {
                               print("Error de decodificación: \(error)")
                           }
                       } else if let error = error {
                           print("Error de solicitud: \(error)")
                       }
                   }.resume()
    }
    
    func acceptFriend(){
        
    }
    
    func FriendListView(friend: Usuario) -> some View {
        
        
            VStack(alignment: .leading) {
                
                HStack{
                    Image(systemName: "person.circle.fill")
                        .font(.title2)
                    Text("@\(friend.usuario ?? "N/A")")
                        .bold()
                        .font(.callout)
                    Spacer()
                    if friendStatus == .accepted {
                        // TO SEE FRIEND WATCHING
                        NavigationLink(destination: UserWatchingView(friend: [friend], isFor: .watching)) {
                            Image(systemName: AnimeWatchingButton(animeId: 0, selectedOption: .watching, changeOptionImageSize: 20).icoImage)
                                .font(.title2)
                                .foregroundStyle(AnimeWatchingButton(animeId: 0, selectedOption: .watching, changeOptionImageSize: 20).iconColor)
                        }
                        // TO SEE FRIEND HOLD
                        NavigationLink(destination: UserWatchingView(friend: [friend], isFor: .hold)) {
                            Image(systemName: AnimeWatchingButton(animeId: 0, selectedOption: .hold, changeOptionImageSize: 20).icoImage)
                                .font(.title2)
                                .foregroundStyle(AnimeWatchingButton(animeId: 0, selectedOption: .hold, changeOptionImageSize: 20).iconColor)
                        }
                        NavigationLink(destination: UserWatchingView(friend: [friend], isFor: .completed)) {
                            Image(systemName: AnimeWatchingButton(animeId: 0, selectedOption: .completed, changeOptionImageSize: 20).icoImage)
                                .font(.title2)
                                .foregroundStyle(AnimeWatchingButton(animeId: 0, selectedOption: .completed, changeOptionImageSize: 20).iconColor)
                        }
                    } else {
                        Button(action: {
                            
                            updateFriendRequest(userId1: friend.id ?? "N/A", userId2: AccountVm.sharedUserVM.userActual.first?.id ?? "N/A", newStatus: "accepted")
                        } ){
                            Text("Accept")
                                .foregroundStyle(.blue).bold()
                        }
                        Button(action: {
                            
                        } ){
                            Text("Reject")
                                .foregroundStyle(.red).bold()
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color("barColor"))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .foregroundStyle(.white)
                // Puedes mostrar otros campos de amigo aquí
            }
        
        
    }
    
    func updateFriendRequest(userId1: String, userId2: String, newStatus : String) {
        guard let url = URL(string: "https://rayjewelry.us/animeLandiaApi/accept_reject_friend.php") else {
                            return
                        }
                        
                        var request = URLRequest(url: url)
                        request.httpMethod = "POST"
                        request.httpBody = "user_id1=\(userId1)&user_id2=\(userId2)&new_status=\(newStatus)".data(using: .utf8)
                        
                        URLSession.shared.dataTask(with: request) { data, response, error in
                            if let data = data {
                                if let responseString = String(data: data, encoding: .utf8) {
                                    print(responseString)
                                    // Manejar la respuesta JSON del servidor aquí si es necesario
                                }
                            } else if let error = error {
                                print("Error: \(error)")
                            }
                        }.resume()
                    }
    }


#Preview {
    FriendsView(friendStatus: .accepted)
}
