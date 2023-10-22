//
//  TopTenView.swift
//  Anime Landia
//
//  Created by Victor Saint Hilaire on 10/9/23.
//

import SwiftUI

struct TopTenView: View {
    // PARA MANEJAR EL COLOR DEL DARK MODE

    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            
           
            
                AnimeTopWatchingView()
                    .frame(height: 300)
                    .padding(.top)
                AnimeTopOnHoldView()
                    .frame(height: 300)
                AnimeTopCompletedView()
                    .frame(height: 300)
                
                    
               
            
        }
            .background(Color("background"))
            .foregroundStyle(.white)
    }
}

#Preview {
    TopTenView()
}
