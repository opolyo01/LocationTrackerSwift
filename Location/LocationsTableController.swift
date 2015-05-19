//
//  NotesTableViewController.swift
//  TodoApp
//
//  Created by Oleg Polyakov on 4/19/15.
//  Copyright (c) 2015 Oleg Polyakov. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import MapKit
import AddressBook

class LocationsTableViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {
    var locations = []
    var coords: CLLocationCoordinate2D?
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    
    func reloadTable(notification: NSNotification){
        //load data here
        locations = Location.fetchLocations(managedObjectContext!)
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadTable:", name:"load", object: nil)
        locations = Location.fetchLocations(managedObjectContext!)
    }
    
    // called when a row deletion action is confirmed
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if(editingStyle == .Delete ) {
            // Find the LogItem object the user is trying to delete
            let locationToDelete: NSManagedObject = locations[indexPath.row] as! NSManagedObject
            
            // Delete it from the managedObjectContext
            Location.deleteLocation(managedObjectContext!, locationToDelete: locationToDelete)
            
            // Refresh the table view to indicate that it's deleted
            locations = Location.fetchLocations(managedObjectContext!)
            
            // Tell the table view to animate out that row
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }

    
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
        println(location.valueForKey("address") as? String)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // load the selected model
        let location: AnyObject = self.locations[indexPath.row]
        
        let address = location.valueForKey("address") as! String
        let cityStateZip = location.valueForKey("cityStateZip") as! String
        
        let geoCoder = CLGeocoder()
        
        let addressString = "\(address) \(cityStateZip)"
        
        geoCoder.geocodeAddressString(addressString, completionHandler:
            {(placemarks: [AnyObject]!, error: NSError!) in
                
                if error != nil {
                    println("Geocode failed with error: \(error.localizedDescription)")
                } else if placemarks.count > 0 {
                    let placemark = placemarks[0] as! CLPlacemark
                    let location = placemark.location
                    self.coords = location.coordinate
                    
                    self.showMap(address, cityStateZip: cityStateZip)
                }
        })
    }
    
    func showMap(address:String, cityStateZip:String){
        let addressDict =
        [kABPersonAddressStreetKey as NSString: address,
            kABPersonAddressCityKey: cityStateZip,
            kABPersonAddressStateKey: "",
            kABPersonAddressZIPKey: ""]
        
        let place = MKPlacemark(coordinate: coords!,
            addressDictionary: addressDict)
        
        let mapItem = MKMapItem(placemark: place)
        
        let options = [MKLaunchOptionsDirectionsModeKey:
        MKLaunchOptionsDirectionsModeDriving]
        
        mapItem.openInMapsWithLaunchOptions(options)
    }
    
}
