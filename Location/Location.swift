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
            
        print("Location \(lat) \(lng)", appendNewline: false)
        
        return newItem
    }
    
    class func fetchLocations(moc: NSManagedObjectContext) -> [NSManagedObject]{
        let fetchRequest = NSFetchRequest(entityName:"Location")
        
        
        do {
            let fetchedResults = try moc.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResults {
                return results
            } else {
                print("Could not fetch", appendNewline: false)
                return []
            }
        } catch {
            print(error)
        }
        
        return []
    }
    
    class func save(moc: NSManagedObjectContext) {
        do{
            try moc.save()
        }
        catch {
            print(error)
        }
        
    }
    
}
