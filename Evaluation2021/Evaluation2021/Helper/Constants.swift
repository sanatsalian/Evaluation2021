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
