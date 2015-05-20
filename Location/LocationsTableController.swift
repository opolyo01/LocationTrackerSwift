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

class LocationsTableViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    var locations = []
    var currentLocation:CLLocation = CLLocation(latitude: 0, longitude: 0)
    var coords: CLLocationCoordinate2D?
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    let locationManager = CLLocationManager()
    
    
    func reloadTable(notification: NSNotification){
        //load data here
        locations = Location.fetchLocations(managedObjectContext!)
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadTable:", name:"load", object: nil)
        locations = Location.fetchLocations(managedObjectContext!)
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        currentLocation = manager.location
        if(!self.tableView.editing){
            self.tableView.reloadData()
        }
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
        let lat = location.valueForKey("lat") as? Double
        let lng = location.valueForKey("lng") as? Double
        let clLocation = CLLocation(latitude: lat!, longitude: lng!)
        let metersInMile = 1609.344
        var address = location.valueForKey("address") as? String
        var distance:Double = clLocation.distanceFromLocation(currentLocation)
        distance = distance/metersInMile
        distance = self.roundToPlaces(distance, places: 2)
        
        //cell.textLabel!.text = address! + " " + distance.description + "mi"
        
        if let addressLabel = cell.viewWithTag(100) as? UILabel { //3
            addressLabel.text = address
        }
        if let distanceLabel = cell.viewWithTag(101) as? UILabel {
            distanceLabel.text = distance.description + "mi"
        }
        println("Distance \(distance)")
        
        return cell
    }
    
    func roundToPlaces(value:Double, places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(value * divisor) / divisor
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // load the selected model
        let location: AnyObject = self.locations[indexPath.row]
        
        let address = location.valueForKey("address") as! String
        let city = location.valueForKey("city") as! String
        let state = location.valueForKey("state") as! String
        let zipCode = location.valueForKey("zipCode") as! String
        let lat = location.valueForKey("lat") as? Double
        let lng = location.valueForKey("lng") as? Double
        let clLocation = CLLocation(latitude: lat!, longitude: lng!)
        coords = clLocation.coordinate
        
        self.showMap(address, city: city, state: state, zipCode: zipCode)
    }
    
    func showMap(address:String, city:String, state:String, zipCode:String){
        let addressDict =
        [kABPersonAddressStreetKey as NSString: address,
            kABPersonAddressCityKey: city,
            kABPersonAddressStateKey: state,
            kABPersonAddressZIPKey: zipCode]
        
        let place = MKPlacemark(coordinate: coords!,
            addressDictionary: addressDict)
        
        let mapItem = MKMapItem(placemark: place)
        
        let options = [MKLaunchOptionsDirectionsModeKey:
        MKLaunchOptionsDirectionsModeDriving]
        
        mapItem.openInMapsWithLaunchOptions(options)
    }
    
}
