//
//  CoreDataManager.swift
//  GoscaleAsignment
//
//  Created by TapashM on 14/07/18.
//  Copyright © 2018 ITC Infotech. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataManager {
    
    static func saveGeoLocationData(json: JSON){
        let context = CoreDataStack.shared.persistentContainer.viewContext
        let mGeoLocationData =  GeoLocationData(context: context)
        let location = json["location"]
        mGeoLocationData.lat = location["lat"].doubleValue
        mGeoLocationData.lng = location["lng"].doubleValue
        mGeoLocationData.accuracy = json["accuracy"].doubleValue
        mGeoLocationData.dateTimeStamp =  Date()
        context.performAndWait {
            CoreDataStack.shared.saveContext()
        }
    }
    
    static func getFetchedResultsController(entityName: String,predicate:NSPredicate?,sortingKey: String,context:NSManagedObjectContext) -> NSFetchedResultsController<GeoLocationData> {
        let managedContext = context
        
        // Initialize Fetch Request
        let fetchRequest = GeoLocationData.fetchRequest() as NSFetchRequest
        
        // Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: sortingKey, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Initialize Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
        // Configure Fetched Results Controller
        return fetchedResultsController
    }
    
    static func getGeolocationData(entityName: String,predicate:NSPredicate?,sortingKey: String) -> [GeoLocationData]? {
        
        let context = CoreDataStack.shared.persistentContainer.viewContext
        // Initialize Fetch Request
        let fetchRequest = GeoLocationData.fetchRequest() as NSFetchRequest
        
        // Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: sortingKey, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let result = try context.fetch(fetchRequest)
            return result

        } catch {
            print("No contacts found")
        }
        
        return nil
    }
   
}
