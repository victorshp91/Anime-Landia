//
//  HelpersFunctions.swift
//  Anime Landia
//
//  Created by Victor Saint Hilaire on 9/30/23.
//

import Foundation
import SwiftUI


class HelpersFunctions {
    
    enum animeWatchingOptions: String, CaseIterable, Identifiable {
        case watching = "watching"
        case hold = "on hold"
        case completed = "completed"
        case none = "none"
        
        var id: String {self.rawValue}
    }
    
    
    
    enum searchingType: String,CaseIterable, Identifiable  {
        case anime = "anime"
        case character = "character"
        
        var id: String { self.rawValue }
    }
    
    enum filtreAnimeType: String, CaseIterable, Identifiable {
        case all = "ALL"
        case tv = "TV"
        case movie = "MOVIE"
        case ova = "OVA"
        case special = "SPECIAL"
        case ona = "ONA"
        case music = "MUSIC"
        
        var id: String { self.rawValue }
    }
    
    
    
    
    func truncateText(text: String, maxWords: Int = 15) -> String {
        let words = text.split(separator: " ")
        let truncatedText = words.prefix(maxWords).joined(separator: " ")
        return truncatedText + (words.count > maxWords ? "" : "")
    }
    
  
    
    struct NoDataView: View {
        var body: some View {
            VStack {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 100))
                    .foregroundColor(.gray)
                    .padding(.bottom, 20)
                
                Text("NO DATA")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
            }
            
            
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            .background(Color("barColor"))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        
    }
    
    /// DISENO BOTON PARA EL MENU DE LA VISTA DE LA CUENTA DEL USUARIO

    struct BotonMenuAccount: View {
        
        var icono: String
        var titulo: String
        var color: Color
        
        var body: some View {
            HStack {
                Image(systemName: icono)
                    .font(.title2)
                
                Text(titulo)
                
                Spacer()
            }.frame(maxWidth: .infinity)
                .font(.headline)
                .foregroundStyle(.white)
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(color)
                )
        }
    }
    
}
