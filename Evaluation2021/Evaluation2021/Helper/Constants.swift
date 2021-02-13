//
//  Constants.swift
//  Evaluation2021
//
//  Created by Sanat Salian on 12/02/21.
//  Copyright © 2021 Sanat Salian. All rights reserved.
//

import Foundation


enum AppConstants {
    static let homeNavigation = "NavigationView"
    static let homeScreentabCellIdentifier = "HomeScreenCategoryCollectionViewCell"
    static let homeScreenTableViewCellCellIdentifier = "HomeScreenTableViewCell"
    static let genericError = "Something went wrong"
    static let authorizationKey = "Authorization"

}

enum HomeScreenTabs: Int {
    case photos = 0, videos = 1, favorites = 2
    
    static var numberOfTabs: Int {
        return 3
    }
    
    var title: String {
        switch self {
        case .photos:
            return "Photos"
        case .videos:
            return "Videos"
        case .favorites:
            return "Favorites"

        }
    }
}


let baseUrl = "https://api.pexels.com"
let version = "/v1"
let APIKey = "563492ad6f91700001000001fd79d40a657042268713198c35b46653"

enum API: String {
    
    case search = "/search"
    case videos = "/videos/popular"
    
    var withBaseURL: String {
        return baseUrl + version + self.rawValue
    }
}


enum Mediatype {
    
    case photo 
    case video
}
