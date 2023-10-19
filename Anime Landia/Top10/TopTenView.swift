//
//  TopTenView.swift
//  Anime Landia
//
//  Created by Victor Saint Hilaire on 10/9/23.
//

import SwiftUI

struct TopTenView: View {
    // PARA MANEJAR EL COLOR DEL DARK MODE
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            
            VStack(alignment: .leading){
            
                AnimeTopWatchingView()
                    .frame(height: 300)
                AnimeTopOnHoldView()
                    .frame(height: 300)
                AnimeTopCompletedView()
                    .frame(height: 300)
                
                    
                Spacer()
            }.padding(.top)
        }
            .background(Color("background"))
            .foregroundStyle(.white)
    }
}

#Preview {
    TopTenView()
}
