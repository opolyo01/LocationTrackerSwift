//
//  Location.swift
//  Location
//
//  Created by Oleg Polyakov on 5/18/15.
//  Copyright (c) 2015 Oleg Polyakov. All rights reserved.
//

import Foundation

import CoreData

@objc(Location)
class Location: NSManagedObject {
    
    @NSManaged var address: String
    @NSManaged var city: String
    @NSManaged var state: String
    @NSManaged var zipCode: String
    @NSManaged var lat: Double
    @NSManaged var lng: Double
    
    class func deleteLocation(moc: NSManagedObjectContext, locationToDelete:NSManagedObject){
        moc.deleteObject(locationToDelete as NSManagedObject)
        Location.save(moc)
    }
    
    class func addLocation(moc: NSManagedObjectContext, address: String, city: String,
        state: String, zip: String, lat: Double, lng: Double) -> Location {
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("Location", inManagedObjectContext: moc) as! Location
        newItem.address = address
        newItem.city = city
        newItem.state = state
        newItem.zipCode = zip
        newItem.lat = lat
        newItem.lng = lng
        Location.save(moc)
            
        println("Location \(lat) \(lng)")
        
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
    
    class func save(moc: NSManagedObjectContext) {
        var error : NSError?
        if(moc.save(&error) ) {
            println("Error \(error?.localizedDescription)")
        }
    }
    
}
