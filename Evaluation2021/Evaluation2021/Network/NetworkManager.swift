//
//  NetworkManager.swift
//  Evaluation2021
//
//  Created by Sanat Salian on 13/02/21.
//  Copyright © 2021 Sanat Salian. All rights reserved.
//

import Foundation


enum APIParams {
    
    static let page = "page"
    static let perPage = "per_page"
    static let query = "query"
}

enum Status {
    case ok
    case error
}

struct APIResponse {
    var status:Status
    var errorMessage: String?
    var data: Codable?
}



class NewtworkManager: NSObject {
    
    class func loadPhotos(of query: String, page: Int, perPage: Int, completion: @escaping  (APIResponse) -> ()) {
        
        guard var url = URL(string: API.search.withBaseURL) as NSURL? else { return }
        url = url.append(key: APIParams.page,value: "\(page)") as NSURL
        url = url.append(key: APIParams.perPage,value: "\(perPage)") as NSURL
        url = url.append(key: APIParams.query,value: query) as NSURL
        
        var request = URLRequest(url: (url as? URL)!)
        request.httpMethod = "GET"
        request.setValue(APIKey, forHTTPHeaderField: AppConstants.authorizationKey)
        
        
        let task = URLSession.shared.dataTask(with: request ) {(data, response, error) in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                if let photos: PhotoObject = try decoder.decode(PhotoObject.self, from: data) {
                    let apiResponse = APIResponse(status: .ok, errorMessage: nil, data: photos)
                    completion(apiResponse)
                } else if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    let apiResponse = APIResponse(status: .error, errorMessage: json["code"] as? String, data: nil)
                    completion(apiResponse)
                }
            } catch {
                let apiResponse = APIResponse(status: .error, errorMessage: AppConstants.genericError, data: nil)
                completion(apiResponse)
            }
           
        }
        task.resume()
    }
}

extension NSURL {
    
    @objc func append(key: String,value: String?) -> URL {
        guard var urlComponents = URLComponents(string: absoluteString!) else {
            return absoluteURL!
        }
        
        var paramsItems: [URLQueryItem] = urlComponents.queryItems ?? []
        let paramItem: URLQueryItem = URLQueryItem(name: key, value: value)
        paramsItems.append(paramItem)
        urlComponents.queryItems = paramsItems
        
        return urlComponents.url!

    }
}

