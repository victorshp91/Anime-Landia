//
//  usuarioData.swift
//  Anime Landia
//
//  Created by Victor Saint Hilaire on 10/4/23.
//

import Foundation


struct Favorito: Identifiable, Decodable {
    let id_usuario: String
    let id_anime: String
    let fecha: String
    
    var id: String { id_usuario + id_anime }
}
