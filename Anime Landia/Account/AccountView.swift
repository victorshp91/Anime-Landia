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
    
    var body: some View {
        ScrollView {
            VStack(alignment:.leading){
                HStack{
                    Image(systemName: "person.circle.fill")
                    Text("Bienvenido")
                    Text("\(userData.userActual.first?.usuario ?? "")")
                        .bold()
                }
                
                Button(action: {
                    if AccountVm.sharedUserVM.userActual.isEmpty {
                        showLogin = true
                    } else {
                        // al cerrar sesion se borra los datos del usuario
                        AccountVm.sharedUserVM.userActual.removeFirst()
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
                
                
                
                VStack(alignment: .leading){
                    Text("Favorites").bold().font(.title2)
                    NavigationLink(destination: userFavoritesView(isFor: .character)){
                        HelpersFunctions.BotonMenuAccount(icono: "star.circle.fill", titulo: "My Favorites Characters", color: .cyan)
                    }
                    NavigationLink(destination: userFavoritesView(isFor: .anime)) {
                        HelpersFunctions.BotonMenuAccount(icono: "star.fill", titulo: "My Favorites Animes", color: .cyan)
                    }
                    
                    Text("Anime").bold().font(.title2)
                    NavigationLink(destination: UserWatchingView(isFor: .watching)) {
                        HelpersFunctions.BotonMenuAccount(icono: "eye.circle.fill", titulo: "Watching", color: .blue)
                    }
                    
                    NavigationLink(destination: UserWatchingView(isFor: .completed)) {
                        HelpersFunctions.BotonMenuAccount(icono: "checkmark.circle.fill", titulo: "Completed", color: .green)
                        
                    }
                    NavigationLink(destination: UserWatchingView(isFor: .hold)) {
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
