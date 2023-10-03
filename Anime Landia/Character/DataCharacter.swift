import SwiftUI

struct CharacterData: Codable {
    
    let pagination: Pagination
    let data: [AnimeCharacter]
}

struct AnimeCharacter: Codable, Identifiable {
    
    let mal_id: Int
    let url: String?
    let images: CharacterImages?
    let name: String?
    let nameKanji: String?
    let nicknames: [String]?
    let favorites: Int?
    let about: String?
    
    var id: Int {
        return mal_id
    }
}

struct CharacterImages: Codable {
    let jpg: ImageInfo
    let webp: ImageInfo
}

struct ImageInfo: Codable {
    let image_url: String
    let small_image_url: String?
}
