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
                
                
            })
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(searchText.isEmpty ? friends:filteredUsers, id: \.id) { friend in
                   FriendListView(friend: friend)
                }
            }
            Spacer()
        }.navigationTitle(friendStatus == .accepted ? "Friends":"Friend Requests")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if friendStatus == .accepted {
                        
                        Image(systemName: "plus.circle.fill").foregroundColor(.cyan).font(.title2)
                    }
                    
                }
            }
            .onAppear(perform: {
                getFriends()
            })
            .padding(.horizontal)
            .background(Color.gray.opacity(0.1))
    }
    
    func getFriends(){
        
        guard let url = URL(string: "\(DataBaseViewModel.sharedDataBaseVM.hosting)\(DataBaseViewModel.sharedDataBaseVM.getUserFriends)user_id=\(AccountVm.sharedUserVM.userActual.first?.id ?? "")&status=\(friendStatus.rawValue.lowercased())") else {
                       return
                   }

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
    
    func FriendListView(friend: Usuario) -> some View {
        
        
            VStack(alignment: .leading) {
                
                HStack{
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
                            
                        } ){
                            Text("Accept")
                                .foregroundStyle(.blue).bold()
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .foregroundStyle(.black)
                // Puedes mostrar otros campos de amigo aquí
            }
        
        
    }
}

#Preview {
    FriendsView(friendStatus: .accepted)
}
