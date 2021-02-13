//
//  Photo.swift
//  Evaluation2021
//
//  Created by Sanat Salian on 13/02/21.
//  Copyright © 2021 Sanat Salian. All rights reserved.
//

import Foundation

struct PhotoObject: Codable {
    
    var page: Int?
    var perPage: Int?
    var photos: [Photo]?
    var totalResults: Int?
    var nextPage: String?
    var previousPage: String?
    
   
    enum CodingKeys: String,CodingKey {
        case page = "page"
        case perPage = "per_page"
        case photos = "photos"
        case totalResults = "total_results"
        case nextPage = "next_page"
        case previousPage = "prev_page"
    }

}

struct Photo: Codable {
    
    var id: Int?
    var width: Double?
    var height: Double?
    var photoUrl: String?
    var photographer: String?
    var photographerUrl: String?
    var photographerId: Int?
    var liked: Bool?
    var source: Source?
   
    enum CodingKeys: String,CodingKey {
        case id = "id"
        case width = "width"
        case height = "height"
        case photoUrl = "url"
        case photographer = "photographer"
        case photographerUrl = "photographer_url"
        case photographerId = "photographer_id"
        case source = "src"
        case liked = "liked"
    }

}

struct Source: Codable {
    var originalPhoto: String?
    
    
    enum CodingKeys: String,CodingKey {
        case originalPhoto = "original"
        
    }
}
