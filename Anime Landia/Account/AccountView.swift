//
//  AccountView.swift
//  Anime Landia
//
//  Created by Victor Saint Hilaire on 10/3/23.
//

import SwiftUI

struct AccountView: View {
    var body: some View {
        ScrollView {
            VStack(alignment:.leading){
                HelpersFunctions.BotonMenuAccount(icono: "arrowshape.turn.up.right.circle.fill", titulo: "Sign Out", color: .red)
                Text("Favorites").bold().font(.title2)
                HelpersFunctions.BotonMenuAccount(icono: "star.circle.fill", titulo: "My Favorites Characters", color: .cyan)
                HelpersFunctions.BotonMenuAccount(icono: "star.fill", titulo: "My Favorites Animes", color: .cyan)
                Text("Anime").bold().font(.title2)
                HelpersFunctions.BotonMenuAccount(icono: "eye.circle.fill", titulo: "Watching", color: .blue)
                HelpersFunctions.BotonMenuAccount(icono: "checkmark.circle.fill", titulo: "Completed", color: .green)
                HelpersFunctions.BotonMenuAccount(icono: "pause.circle.fill", titulo: "On Hold", color: .gray)
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
