//
//  DataTopAnime.swift
//  Anime Landia
//
//  Created by Victor Saint Hilaire on 9/30/23.
//

import SwiftUI

struct AnimeData: Codable {
    let pagination: Pagination?
    let data: [Anime]
}

struct OnlyAnimeData: Codable {
    let data: Anime?
}

struct Pagination: Codable {
    let last_visible_page: Int
    let has_next_page: Bool
    let current_page: Int
    let items: ItemCount
}

struct ItemCount: Codable {
    let count: Int
    let total: Int
    let per_page: Int
}

struct Anime: Codable, Identifiable {
    let mal_id: Int?
    let url: String?
    let images: Images?
    let trailer: Trailer?
    let approved: Bool?
    let titles: [Title]?
    let title: String?
    let title_english: String?
    let title_japanese: String?
    let title_synonyms: [String]?
    let type: String?
    let source: String?
    let episodes: Int?
    let status: String?
    let airing: Bool?
    let aired: Aired?
    let duration: String?
    let rating: String?
    let score: Double?
    let scored_by: Int?
    let rank: Int?
    let popularity: Int?
    let members: Int?
    let favorites: Int?
    let synopsis: String?
    let background: String?
    let season: String?
    let year: Int?
    let broadcast: Broadcast?
    let producers: [Producer]?
    let licensors: [Licensor]?
    let studios: [Studio]?
    let genres: [Genre]?
    let explicit_genres: [Genre]?
    let themes: [Genre]?
    let demographics: [Genre]?
    
    var id: Int? {
        return mal_id
    }
    
    init(mal_id: Int? = nil, url: String? = nil, images: Images? = nil, trailer: Trailer? = nil, approved: Bool? = nil, titles: [Title]? = nil, title: String? = nil, title_english: String? = nil, title_japanese: String? = nil, title_synonyms: [String]? = nil, type: String? = nil, source: String? = nil, episodes: Int? = nil, status: String? = nil, airing: Bool? = nil, aired: Aired? = nil, duration: String? = nil, rating: String? = nil, score: Double? = nil, scored_by: Int? = nil, rank: Int? = nil, popularity: Int? = nil, members: Int? = nil, favorites: Int? = nil, synopsis: String? = nil, background: String? = nil, season: String? = nil, year: Int? = nil, broadcast: Broadcast? = nil, producers: [Producer]? = nil, licensors: [Licensor]? = nil, studios: [Studio]? = nil, genres: [Genre]? = nil, explicit_genres: [Genre]? = nil, themes: [Genre]? = nil, demographics: [Genre]? = nil) {
        
        self.mal_id = mal_id
        self.url = url
        self.images = images
        self.trailer = trailer
        self.approved = approved
        self.titles = titles
        self.title = title
        self.title_english = title_english
        self.title_japanese = title_japanese
        self.title_synonyms = title_synonyms
        self.type = type
        self.source = source
        self.episodes = episodes
        self.status = status
        self.airing = airing
        self.aired = aired
        self.duration = duration
        self.rating = rating
        self.score = score
        self.scored_by = scored_by
        self.rank = rank
        self.popularity = popularity
        self.members = members
        self.favorites = favorites
        self.synopsis = synopsis
        self.background = background
        self.season = season
        self.year = year
        self.broadcast = broadcast
        self.producers = producers
        self.licensors = licensors
        self.studios = studios
        self.genres = genres
        self.explicit_genres = explicit_genres
        self.themes = themes
        self.demographics = demographics
    }
    
}

struct Images: Codable {
    let jpg: ImageURL
    let webp: ImageURL
}

struct ImageURL: Codable {
    let image_url: String
    let small_image_url: String
    let large_image_url: String
}

struct Trailer: Codable {
    let youtube_id: String?
    let url: String?
    let embed_url: String?
    let images: TrailerImages
}

struct TrailerImages: Codable {
    let image_url: String?
    let small_image_url: String?
    let medium_image_url: String?
    let large_image_url: String?
    let maximum_image_url: String?
}

struct Title: Codable {
    let type: String
    let title: String
}

struct Aired: Codable {
    let from: String?
    let to: String?
    let prop: AiredDates
    let string: String?
}

struct AiredDates: Codable {
    let from: DateComponents
    let to: DateComponents
}

struct Broadcast: Codable {
    let day: String?
    let time: String?
    let timezone: String?
    let string: String?
}

struct Producer: Codable {
    let mal_id: Int
    let type: String
    let name: String
    let url: String
}

struct Licensor: Codable {
    let mal_id: Int
    let type: String
    let name: String
    let url: String
}

struct Studio: Codable {
    let mal_id: Int
    let type: String
    let name: String
    let url: String
}

struct Genre: Codable {
    let mal_id: Int
    let type: String
    let name: String
    let url: String
}

// PARA LOS DATOS DE LOS CONTEO DE LOS WATCHING STATUS Y LOS TOP DE CADA WATCHING STATUS

struct AnimeWatchingStatusTotals: Codable {
    let id: Int
    let id_anime: Int?
    let favorites: Int
    let watching: Int
    let on_hold: Int
    let completed: Int
}

struct RatingResponse: Decodable {
    let total_pages: Int?
    let current_page: String?
    let total_ratings: Int?
    let ratings: [Rating]?
    let average: Double?
}
// PARA LOS DATOS DE LOS RATINGS
struct Rating: Identifiable, Codable {
    var id: String?
    var user_id: String?
    var anime_id: String?
    var rating: String?
    var comment: String?
    var created_at: String?
    var usuario: String?
    var email: String?
    var spoiler: Bool?
    
}

struct RatingAverageResponse: Decodable {
    let average: Double
}





