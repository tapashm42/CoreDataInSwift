//
//  CoreDataManager.swift
//  CoreDataDemo
//
//  Created by TapashM on 19/05/18.
//  Copyright © 2018 TapashM. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataManager {
    
    static func insertEmployee(context:NSManagedObjectContext ){
        let now = Date().currentTimeMillis
        print(now)
        
        for i in 1 ... 100000 {
            let mEmployee =  Employee(context: context)
            mEmployee.name = String(format:"Employee_%d",i)
            mEmployee.empID = Int64(i)
            mEmployee.age = 30
            mEmployee.designation =  (i%2 == 0) ? "Associate IT Consultant" : "IT Consultant"
        }
        context.performAndWait {
            CoreDataStack.shared.saveContext()
        }
        print(Date().currentTimeMillis - now)
    }
    
   static func getFetchedResultsController(entityName: String,predicate:NSPredicate?,sortingKey: String,context:NSManagedObjectContext) -> NSFetchedResultsController<Employee> {
        let managedContext = context
    
    // Initialize Fetch Request
//    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Employee")
    
    let fetchRequest = Employee.fetchRequest() as NSFetchRequest
    
//    let fetchRequest = Employee.fetchRequest()

    // Add Sort Descriptors
    let sortDescriptor = NSSortDescriptor(key: sortingKey, ascending: true)
    fetchRequest.sortDescriptors = [sortDescriptor]
    
    // Initialize Fetched Results Controller
    let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil) as! NSFetchedResultsController<Employee>
    
    do {
        try fetchedResultsController.performFetch()
    } catch {
        fatalError("Failed to initialize FetchedResultsController: \(error)")
    }
    // Configure Fetched Results Controller
    return fetchedResultsController
    }
    
    static func batchUpdate(entityName: String,context:NSManagedObjectContext)  {
        let batchUpdateRequest = NSBatchUpdateRequest(entityName: entityName)
        batchUpdateRequest.propertiesToUpdate = ["name":"Tapash Mollick","designation":"Associate IT Consultant"]
        batchUpdateRequest.resultType = .updatedObjectIDsResultType
        do {
            let start = Date().currentTimeMillis
            let batchUpdateResult = try context.execute(batchUpdateRequest) as! NSBatchUpdateResult
            
            let result = batchUpdateResult.result as! [NSManagedObjectID]
            print("time taken to update\(Date().currentTimeMillis - start)")
            
            for objectId in result {
                let manageObject = context.object(with: objectId)
                if (!manageObject.isFault) {
                context.stalenessInterval = 0
                context.refresh(manageObject, mergeChanges: true)
                }
            }
        }
        catch{
            fatalError("Unable to batchUpdate")
        }
    }
    
    static func batchDelete(entityName: String,context:NSManagedObjectContext)  {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetch.predicate = NSPredicate(format:"designation==%@","Associate IT Consultant")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetch)
        do {
            let start = Date().currentTimeMillis
            let batchDeleteResult = try context.execute(batchDeleteRequest) as? NSBatchDeleteResult
            let objectIDArray = batchDeleteResult?.result as? [NSManagedObjectID]

            let changes = [NSDeletedObjectsKey:objectIDArray]
            print("time taken to batch delete\(Date().currentTimeMillis - start)")
            context.refreshAllObjects()

//            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: (changes ?? nil)!, into: [context])
        }
        catch{
            fatalError("Unable to batchDelete")
        }
    }
}
