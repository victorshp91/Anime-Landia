//
//  DataBaseVM.swift
//  Anime Landia
//
//  Created by Victor Saint Hilaire on 10/8/23.
//

import Foundation


class DataBaseViewModel {
    
    static let sharedDataBaseVM = DataBaseViewModel()
    
    let hosting = "https://rayjewelry.us/animeLandiaApi/"
    
    let getUser = "get_user.php?"
    let saveUser = "guardar_usuario.php?"
    let getIfAnimeIsFavorite = "get_anime_favorite.php?"
    let getIfCharactersIsFavorites = "get_characters_favorites.php?"
    let getAnimeWatchingStatus = "get_anime_watching_status.php?"
    let saveCharacterAsFavorite =  "guardar_favorito_character.php?"
    let saveWatchingStatusOrFavorite = "guardar_favorito_watching.php?"
    let getAnimeWatchingStatusNumbers = "get_anime_watching_numbers.php?"
    let changeWatchingStatusNumbers = "change_watching_status_numbers.php?"
    let getTopAnimeByWatchingStatus = "get_top_watching_status.php?"
    
    
 // https://rayjewelry.us/animeLandiaApi/change_watching_status_numbers.php?id_anime=9367&campo=watching&accion=disminuir
    
}
