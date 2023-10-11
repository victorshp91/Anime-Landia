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
                
                    .navigationTitle("Top 10")
                Spacer()
            }
        }
            .background(Color.gray.opacity(0.1))
            .foregroundStyle(colorScheme == .dark ? .white:.black)
    }
}

#Preview {
    TopTenView()
}
