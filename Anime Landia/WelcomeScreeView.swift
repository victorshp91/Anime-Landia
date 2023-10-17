//
//  WelcomeScreeView.swift
//  Anime Landia
//
//  Created by Victor Saint Hilaire on 10/7/23.
//

import SwiftUI

struct WelcomeScreeView: View {
    @State private var showLogo = false
    var body: some View {
        VStack{
            if showLogo {
                Image("logo")
                
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(radius: 5)
                    .padding()
            }
        }.onAppear(perform: {
            withAnimation {
                showLogo = true
            }
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("barColor"))
        
        
    }
}

#Preview {
    WelcomeScreeView()
}
