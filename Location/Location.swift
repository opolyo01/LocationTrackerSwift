//
//  Location.swift
//  Location
//
//  Created by Oleg Polyakov on 5/18/15.
//  Copyright (c) 2015 Oleg Polyakov. All rights reserved.
//

import Foundation

import CoreData

class Location: NSManagedObject {
    
    @NSManaged var address: String
    @NSManaged var cityStateZip: String
    
    class func addLocation(moc: NSManagedObjectContext, address: String, cityStateZip: String) -> Location {
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("Location", inManagedObjectContext: moc) as! Location
        newItem.address = address
        newItem.cityStateZip = cityStateZip
        
        return newItem
    }
    
    class func fetchLocations(moc: NSManagedObjectContext) -> [NSManagedObject]{
        let fetchRequest = NSFetchRequest(entityName:"Location")
        
        //3
        var error: NSError?
        
        let fetchedResults =
        moc.executeFetchRequest(fetchRequest,
            error: &error) as? [NSManagedObject]
        
        if let results = fetchedResults {
            return results
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
            return []
        }

    }
    
}
