//
//  AccountView.swift
//  Anime Landia
//
//  Created by Victor Saint Hilaire on 10/3/23.
//

import SwiftUI

struct AccountView: View {
    
    var userData = AccountVm.sharedUserVM
    
    @State private var showLogin = false
    @State private var isShowingLogoutView = false

   
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment:.leading){
                HStack{
                    Image(systemName: "person.circle.fill")
                    Text("Welcome")
                    Text("\(userData.userActual.first?.usuario ?? "")")
                        .bold()
                }
                
                Button(action: {
                    if AccountVm.sharedUserVM.userActual.isEmpty {
                        showLogin = true
                    } else {
                        isShowingLogoutView.toggle()
                        
                    }
                }) {
                    HelpersFunctions.BotonMenuAccount(icono: "arrowshape.turn.up.right.circle.fill", titulo: userData.userActual.isEmpty ? "Sign In":"Sign Out", color: userData.userActual.isEmpty ? .green:.red)
                }
                    .sheet(isPresented: $showLogin) {
                        NavigationStack {
                            SignInView(isLoginPresented: $showLogin)
                                .presentationDetents([.medium, .large])
                        }
                    }
                    .sheet(isPresented: $isShowingLogoutView) {
                                SignOutConfirmationView(isShowingLogoutView: $isShowingLogoutView)
                            .presentationDetents([.medium])
                            }

                
                
                
                VStack(alignment: .leading){
                    Text("Friends").bold().font(.title2)
                    NavigationLink(destination: FriendsView(friendStatus: AccountVm.friendStatus.accepted)){
                        HelpersFunctions.BotonMenuAccount(icono: "person.2.circle.fill", titulo: "Friends", color: .orange)
                    }
                    NavigationLink(destination: FriendsView(friendStatus: AccountVm.friendStatus.pending)){
                        HelpersFunctions.BotonMenuAccount(icono: "bell.badge.circle.fill", titulo: "Otaku Connections", color: .orange)
                    }
                   
                    Text("Favorites").bold().font(.title2)
                    NavigationLink(destination: userFavoritesView(isFor: .character)){
                        HelpersFunctions.BotonMenuAccount(icono: "star.circle.fill", titulo: "My Favorites Characters", color: .cyan)
                    }
                    NavigationLink(destination: userFavoritesView(isFor: .anime)) {
                        HelpersFunctions.BotonMenuAccount(icono: "star.fill", titulo: "My Favorites Animes", color: .cyan)
                    }
                    
                    Text("Anime").bold().font(.title2)
                    NavigationLink(destination: UserWatchingView(friend: .init(), isFor: .watching)) {
                        HelpersFunctions.BotonMenuAccount(icono: "eye.circle.fill", titulo: "Watching", color: .blue)
                    }
                    
                    NavigationLink(destination: UserWatchingView(friend: .init(), isFor: .completed)) {
                        HelpersFunctions.BotonMenuAccount(icono: "checkmark.circle.fill", titulo: "Completed", color: .green)
                        
                    }
                    NavigationLink(destination: UserWatchingView(friend: .init(), isFor: .hold)) {
                        HelpersFunctions.BotonMenuAccount(icono: "pause.circle.fill", titulo: "On Hold", color: .gray)
                        
                    }
                }.disabled(userData.userActual.isEmpty)
                    .opacity(
                        userData.userActual.isEmpty ? 0.3:1
                    )
                
                    
                
                Text("Share").bold().font(.title2)
                ShareLink(item: URL(string: "https://apps.apple.com/us/app/data-ball-z/id1672899053")!) {
                    HelpersFunctions.BotonMenuAccount(icono: "shareplay", titulo: "Share this app", color: .cyan)
                    
                }
                Text("About").bold().font(.title2)
                NavigationLink(destination: AboutView()){
                    HelpersFunctions.BotonMenuAccount(icono: "info.circle.fill", titulo: "About", color: .cyan)
                }
                Text("Disclaimer").bold().font(.title2)
                VStack(alignment:.leading, spacing: 10){
                    Text("AnimeTracker Pro provides information about animes and characters for informational and entertainment purposes. We are not affiliated with the copyright holders of the animes mentioned in this application.")
                                    
                                    Text("All information, images, and content related to animes are the property of their respective owners and are used here for informational purposes.")
                                    
                                    Text("If you are the copyright owner of any content used in this application and wish for it to be removed or modified, please contact us, and we will address your requests promptly.")
                                    
                                    Text("This app is not intended to infringe upon any copyright and is offered as a reference tool for anime enthusiasts.")
                                    
                                    Text("All trademarks and copyrights belong to their respective owners. This application does not intend to usurp any copyright or infringe upon the intellectual property rights of third parties.")
                                    
                                    Text("Thank you for using our app.")
                }.font(.footnote)
                    .foregroundStyle(.secondary)
                Spacer()
            }
        }.padding(.horizontal)
            .navigationTitle("MY ACCOUNT")
          
            .background(Color.gray.opacity(0.1))
      
    }
}

#Preview {
    AccountView()
}
