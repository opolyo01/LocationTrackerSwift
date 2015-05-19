//
//  NotesTableViewController.swift
//  TodoApp
//
//  Created by Oleg Polyakov on 4/19/15.
//  Copyright (c) 2015 Oleg Polyakov. All rights reserved.
//

import UIKit
import CoreData

class LocationsTableViewController: UITableViewController {
    var locations = []
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.fetchLocations()
    }
    
    func fetchLocations(){
        //2
        let fetchRequest = NSFetchRequest(entityName:"Location")
        
        //3
        var error: NSError?
        
        let fetchedResults =
        managedObjectContext!.executeFetchRequest(fetchRequest,
            error: &error) as? [NSManagedObject]
        
        if let results = fetchedResults {
            locations = results
            println("locations \(locations.count)")
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }

    }
    
    func save() {
        var error : NSError?
        if(managedObjectContext!.save(&error) ) {
            println("Error \(error?.localizedDescription)")
        }
    }
    
    // called when a row deletion action is confirmed
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if(editingStyle == .Delete ) {
            // Find the LogItem object the user is trying to delete
            let locationToDelete: AnyObject = locations[indexPath.row]
            
            // Delete it from the managedObjectContext
            managedObjectContext?.deleteObject(locationToDelete as! NSManagedObject)
            
            // Refresh the table view to indicate that it's deleted
            self.fetchLocations()
            
            // Tell the table view to animate out that row
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            
            save()
        }
    }
//    // called when a row is moved
//    override func tableView(tableView: UITableView,
//        moveRowAtIndexPath sourceIndexPath: NSIndexPath,
//        toIndexPath destinationIndexPath: NSIndexPath) {
//            // remove the dragged row's model
//            let val = self.locations.removeObjectAtIndex(sourceIndexPath.row)
//            
//            // insert it into the new position
//            self.locations.insertObject(val, atIndex: destinationIndexPath.row)
//    }

    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("locationCell", forIndexPath: indexPath) as! UITableViewCell
        
        let location: AnyObject = locations[indexPath.row]
        cell.textLabel!.text = location.valueForKey("address") as? String
        
        return cell
    }
    
}
