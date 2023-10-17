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
            
            LazyVStack(alignment: .leading){
            
                AnimeTopViewByWatchingStatus(watchingStatus: .watching)
                    .frame(height: 300)
                AnimeTopViewByWatchingStatus(watchingStatus: .hold)
                    .frame(height: 300)
                AnimeTopViewByWatchingStatus(watchingStatus: .completed)
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
