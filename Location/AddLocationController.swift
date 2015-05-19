//
//  ViewController.swift
//  Location
//
//  Created by Oleg Polyakov on 5/15/15.
//  Copyright (c) 2015 Oleg Polyakov. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

class AddLocationController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var addressField: UITextField!
    
    @IBOutlet weak var cityStateZipField: UITextField!
    
    let locationManager = CLLocationManager()
    var locations = [NSManagedObject]()
    var currentAddress = ""
    var currentCityStateZip = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error) -> Void in
            
            if error != nil
            {
                println("Error: "+error.localizedDescription)
            }
            
            if placemarks.count > 0{
                let pm = placemarks[0] as! CLPlacemark
                self.displayLocationInfo(pm)
            }
        })
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error "+error.localizedDescription)
    }
    
    func displayLocationInfo(pm:CLPlacemark){
        //self.locationManager.stopUpdatingLocation()
        if pm.thoroughfare != nil && pm.subThoroughfare != nil{
            currentAddress = pm.subThoroughfare + " " + pm.thoroughfare
        }
        if pm.locality != nil && pm.administrativeArea != nil && pm.postalCode != nil{
            currentCityStateZip = pm.locality + " " + pm.administrativeArea + " " + pm.postalCode
        }
        
    }
    
    
    @IBAction func setCurrentLocation(sender: AnyObject) {
        addressField.text = currentAddress
        cityStateZipField.text = currentCityStateZip
    }
    

    @IBAction func addLocation(sender: AnyObject) {
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        //2
        let entity =  NSEntityDescription.entityForName("Location",
            inManagedObjectContext:
            managedContext)
        
        let location = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext:managedContext)
        
        //3
        location.setValue(addressField.text, forKey: "address")
        location.setValue(cityStateZipField.text, forKey: "cityStateZip")
        
        //4
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }
        //5
        locations.append(location)
        
        performSegueWithIdentifier("locations", sender: self)

        println("navigation controllers \(navigationController!.viewControllers)")
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

