//
//  BikeLocation.swift
//  MelbBikes
//
//  Created by Sam Wright on 21/2/19.
//  Copyright © 2019 Sam Wright. All rights reserved.
//

import Foundation
import CoreData

@objc(BikeLocation)
class BikeLocation: NSManagedObject {
    @NSManaged var id: NSNumber
    @NSManaged var locationName: String
    @NSManaged var canPayByCard: Bool
    @NSManaged var canPayByKey: Bool
    @NSManaged var available: NSNumber
    @NSManaged var capacity: NSNumber
    @NSManaged var lat: NSNumber
    @NSManaged var lon: NSNumber
    
    func update(with jsonDictionary: [String: Any]) throws {
        guard let id = Int(jsonDictionary["station_id"] as? String ?? "0"),
            let locationName = jsonDictionary["name"] as? String,
            let rentalMethod = jsonDictionary["rental_method"] as? String,
            let capacity = Int(jsonDictionary["capacity"] as? String ?? "0"),
            let lat = Float(jsonDictionary["lat"] as? String ?? "0.00"),
            let lon = Float(jsonDictionary["lon"] as? String ?? "0.00")
        
        else {
            throw NSError(domain: "", code: 100, userInfo: nil)
        }
        
        self.id = NSNumber(value:id)
        self.locationName = locationName
        self.canPayByCard = rentalMethod.contains("CREDITCARD")
        self.canPayByKey = rentalMethod.contains("KEY")
        self.capacity = NSNumber(value:capacity)
        self.lat = NSNumber(value:lat)
        self.lon = NSNumber(value:lon)

    }
    
    func updateAvailabilities(with jsonDictionary: [String: Any]) throws {
        guard let available = Int(jsonDictionary["available_bikes"] as? String ?? "0")
            else {
                throw NSError(domain: "", code: 100, userInfo: nil)
        }
        
        self.available = NSNumber(value: available)
    }
}
