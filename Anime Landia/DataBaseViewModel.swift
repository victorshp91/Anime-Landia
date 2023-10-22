//
//  DataBaseVM.swift
//  Anime Landia
//
//  Created by Victor Saint Hilaire on 10/8/23.
//

import Foundation


class DataBaseViewModel {
    
    static let sharedDataBaseVM = DataBaseViewModel()
    
    let Dominio = "https://rayjewelry.us/animeLandiaApi/"
    
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
    let getUserFriends = "get_user_friends.php?"
    let searchUsers = "search_user.php?"
    let addNewFriend = "send_friend_request.php?"
    let getAnimeRating = "get_anime_rating.php?" 
    let getRatingFeed = "get_review_feed.php?"
    
    
 // https://rayjewelry.us/animeLandiaApi/change_watching_status_numbers.php?id_anime=9367&campo=watching&accion=disminuir
    
}
