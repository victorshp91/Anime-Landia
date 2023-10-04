import SwiftUI


struct CharacterStruct {
    
    struct CharacterData: Codable {
        
        let pagination: Pagination
        let data: [AnimeCharacter]
    }
    
    struct OnlyCharacterData: Codable {
        let data: AnimeCharacter
    }
    
    struct AnimeCharacter: Codable, Identifiable {
        
        let mal_id: Int?
        let url: String?
        let images: CharacterImages?
        let name: String?
        let nameKanji: String?
        let nicknames: [String]?
        let favorites: Int?
        let about: String?
        
        var id: Int? {
            return mal_id
        }
        
        init(mal_id: Int? = nil, url: String? = nil, images: CharacterImages? = nil, name: String? = nil, nameKanji: String? = nil, nicknames: [String]? = nil, favorites: Int? = nil, about: String? = nil) {
            self.mal_id = mal_id
            self.url = url
            self.images = images
            self.name = name
            self.nameKanji = nameKanji
            self.nicknames = nicknames
            self.favorites = favorites
            self.about = about
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
}

struct AnimeForCharacter {
    
    struct AnimeData: Codable {
        let data: [AnimeItem]
    }

    struct AnimeItem: Codable {
        
        let role: String
        let anime: Anime
    }

    struct Anime: Codable {
        let mal_id: Int
        let url: String
        let images: Images
        let title: String
    }

    struct Images: Codable {
        let jpg: ImageInfo
        let webp: ImageInfo
    }

    struct ImageInfo: Codable {
        let image_url: String
        let small_image_url: String
        let large_image_url: String
    }

    
}
