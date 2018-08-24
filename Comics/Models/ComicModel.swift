//
//  ComicModel.swift
//  Comics
//
//  Created by Maria on 8/23/18.
//  Copyright © 2018 Maria Deygin. All rights reserved.
//

import Foundation

struct ComicModel: Codable {
    
    var id: Int = 0
    var title: String?
    var description: String?
    var prices: [ComicPrice]?
    var thumbnail: ComicImage?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case prices
        case thumbnail
    }
}

struct ComicPrice: Codable {
    var type: String?
    var price: Double?
    
    enum CodingKeys: String, CodingKey {
        case type
        case price
    }
}

struct ComicImage: Codable {
    var path: String?
    var type: String?
    
    enum CodingKeys: String, CodingKey {
        case path
        case type = "extension"
    }
}

extension ComicModel {
    struct Batch: Codable {
        var comics: [ComicModel]?
        
        enum CodingKeys: String, CodingKey {
            case comics = "results"
        }
        
        enum DataKeys: String, CodingKey {
            case data
        }
        
        init(from decoder:Decoder) throws {
            let container = try decoder.container(keyedBy: DataKeys.self)
            let dataContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
            comics = try dataContainer.decodeIfPresent([ComicModel].self, forKey: .comics)
        }

    }
}
