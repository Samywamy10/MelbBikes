//
//  BikeShareLocationsService.swift
//  MelbBikes
//
//  Created by Sam Wright on 21/2/19.
//  Copyright © 2019 Sam Wright. All rights reserved.
//

import Foundation

enum Result <T>{
    case Success(T)
    case Error(String)
}

class BikeShareLocationsService : NSObject {
    private let urlSession = URLSession.shared
    
    func getUrl(url: String, completion: @escaping(_ bikeSharesDict: [[String: Any]]?, _ error: Error?) -> ()) {
        urlSession.dataTask(with: URL(string: url)!) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "ServiceError", code: 1, userInfo: nil)
                completion(nil, error)
                return
            }
            
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                guard let jsonDictionary = jsonObject as? [[String: Any]] else {
                    throw NSError(domain: "ServiceError", code: 2, userInfo: nil)
                }
                completion(jsonDictionary, nil)
            } catch {
                completion(nil, error)
            }
            }.resume()
    }
}
