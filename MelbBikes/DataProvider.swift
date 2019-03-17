//
//  DataProvider.swift
//  MelbBikes
//
//  Created by Sam Wright on 21/2/19.
//  Copyright © 2019 Sam Wright. All rights reserved.
//

import CoreData
import Foundation

class DataProvider {
    
    private let persistentContainer: NSPersistentContainer
    private let repository: BikeShareLocationsService
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(persistentContainer: NSPersistentContainer, repository: BikeShareLocationsService) {
        self.persistentContainer = persistentContainer
        self.repository = repository
    }
    
    func fetchBikeShareLocations(completion: @escaping(Error?) -> Void) {
        repository.getUrl(url: "https://data.melbourne.vic.gov.au/resource/whrp-vp44.json") { jsonDictionary, error in
            if let error = error {
                completion(error)
                return
            }
            
            guard let jsonDictionary = jsonDictionary else {
                let error = NSError(domain: "DataProviderError", code: 3, userInfo: nil)
                completion(error)
                return
            }
            
            let taskContext = self.persistentContainer.newBackgroundContext()
            taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            taskContext.undoManager = nil
            
            _ = self.syncBikeShareLocations(jsonDictionary: jsonDictionary, taskContext: taskContext)
            
            completion(nil)
        }
    }
    
    func fetchBikeShareAvailabilities(completion: @escaping(Error?) -> Void) {
        repository.getUrl(url: "https://data.melbourne.vic.gov.au/resource/tdvh-n9dv.json") { jsonDictionary, error in
            if let error = error {
                completion(error)
                return
            }
            
            guard let jsonDictionary = jsonDictionary else {
                let error = NSError(domain: "DataProviderError", code: 3, userInfo: nil)
                completion(error)
                return
            }
            
            let taskContext = self.persistentContainer.newBackgroundContext()
            taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            taskContext.undoManager = nil
            
            _ = self.syncBikeShareAvailabilities(jsonDictionary: jsonDictionary, taskContext: taskContext)
            
            completion(nil)
        }
    }
    
    private func syncBikeShareLocations(jsonDictionary: [[String: Any]], taskContext: NSManagedObjectContext) -> Bool {
        var successful = false
        taskContext.performAndWait {
            let matchingEpisodeRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BikeLocation")
            let episodeIds = jsonDictionary.map { Int($0["station_id"] as? String ?? "0") }.compactMap { $0 }
            matchingEpisodeRequest.predicate = NSPredicate(format: "id in %@", argumentArray: [episodeIds])
            
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: matchingEpisodeRequest)
            batchDeleteRequest.resultType = .resultTypeObjectIDs
            
            // Execute the request to de batch delete and merge the changes to viewContext, which triggers the UI update
            do {
                let batchDeleteResult = try taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult
                
                if let deletedObjectIDs = batchDeleteResult?.result as? [NSManagedObjectID] {
                    NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSDeletedObjectsKey: deletedObjectIDs],
                                                        into: [self.persistentContainer.viewContext])
                }
            } catch {
                print("Error: \(error)\nCould not batch delete existing records.")
                return
            }
            
            // Create new records.
            for bikeShareLocationDictionary in jsonDictionary {
                
                guard let bikeLocation = NSEntityDescription.insertNewObject(forEntityName: "BikeLocation", into: taskContext) as? BikeLocation else {
                    print("Error: Failed to create a new BikeShareLocation object!")
                    return
                }
                
                do {
                    try bikeLocation.update(with: bikeShareLocationDictionary)
                } catch {
                    print("Error: \(error)\nThe bikeShareLocation object will be deleted.")
                    taskContext.delete(bikeLocation)
                }
            }
            
            
            
            // Save all the changes just made and reset the taskContext to free the cache.
            if taskContext.hasChanges {
                do {
                    try taskContext.save()
                } catch {
                    print("Error: \(error)\nCould not save Core Data context.")
                }
                taskContext.reset() // Reset the context to clean up the cache and low the memory footprint.
            }
            successful = true
        }
        return successful
    }
    
    private func syncBikeShareAvailabilities(jsonDictionary: [[String: Any]], taskContext: NSManagedObjectContext) -> Bool {
        var successful = false
        taskContext.performAndWait {
            let fetchRequest = NSFetchRequest<BikeLocation>(entityName:"BikeLocation")
            for bikeShareLocationDictionary in jsonDictionary {
                do {
                    let station_id = Int(bikeShareLocationDictionary["station_id"] as? String ?? "0")!
                    fetchRequest.predicate = NSPredicate(format: "id = %@", NSNumber(value: station_id))
                    let bikeLocation = try taskContext.fetch(fetchRequest)
                    let available_bikes = NSNumber(value: Int(bikeShareLocationDictionary["available_bikes"] as? String ?? "0")!)
                    bikeLocation.first?.available = available_bikes
                
                } catch {
                    print("Error: \(error)\nFailed to fetch")
                }
            }
            
            // Save all the changes just made and reset the taskContext to free the cache.
            if taskContext.hasChanges {
                do {
                    try taskContext.save()
                } catch {
                    print("Error: \(error)\nCould not save Core Data context.")
                }
                taskContext.reset() // Reset the context to clean up the cache and low the memory footprint.
            }
            successful = true
        }
        return successful
    }
}
