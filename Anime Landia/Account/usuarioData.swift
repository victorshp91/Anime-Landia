//
//  usuarioData.swift
//  Anime Landia
//
//  Created by Victor Saint Hilaire on 10/4/23.
//

import Foundation


struct Favorito: Identifiable, Decodable, Encodable {
    let id: Int?
    let id_usuario: Int
    let id_anime: Int?
    let id_character: Int?
    let favorite: Bool
    let watching: String?
    
    init(id: Int?, id_usuario: Int, id_anime: Int?, favorite: Bool, watching: String?, id_character: Int?) {
        self.id = id
        self.id_usuario = id_usuario
        self.id_anime = id_anime
        self.favorite = favorite
        self.watching = watching
        self.id_character = id_character
    }
}

