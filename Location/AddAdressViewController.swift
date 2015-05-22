//
//  AddAdressViewController.swift
//  Location
//
//  Created by Oleg Polyakov on 5/18/15.
//  Copyright (c) 2015 Oleg Polyakov. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import AddressBook

class AddAdressViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    let locationManager = CLLocationManager()

    @IBOutlet weak var addressLabelField: UITextField!
    @IBOutlet weak var stateLabelField: UITextField!
    @IBOutlet weak var cityLabelField: UITextField!
    @IBOutlet weak var zipLabelField: UITextField!
    
    @IBAction func setCurrentLocation(sender: AnyObject) {
        addressLabelField.text = ""
        cityLabelField.text = ""
        stateLabelField.text = ""
        zipLabelField.text = ""
    }
    
    
    @IBAction func addAddress(sender: AnyObject) {
        let address = addressLabelField.text
        let city = cityLabelField.text
        let state = stateLabelField.text
        let zipCode = zipLabelField.text
        let addressString = "\(address) \(city) \(state) \(zipCode)"
        let geoCoder = CLGeocoder()
        
        geoCoder.geocodeAddressString(addressString, completionHandler:
            {(placemarks: [AnyObject]!, error: NSError!) in
                
                if error != nil {
                    println("Geocode failed with error: \(error.localizedDescription)")
                } else if placemarks.count > 0 {
                    let placemark = placemarks[0] as! CLPlacemark
                    let location = placemark.location
                    let coords = location.coordinate
                    let lat = coords.latitude
                    let lng = coords.longitude
                    
                    Location.addLocation(self.managedObjectContext!, address: address, city: city,
                        state: state, zip: zipCode, lat: lat, lng: lng)
                    self.navigationController?.popViewControllerAnimated(true)
                    NSNotificationCenter.defaultCenter().postNotificationName("load", object: nil)
                }
        })
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
                println("Reverse geocoder failed with error" + error.localizedDescription)
                return
            }
            
            if placemarks.count > 0 {
                let pm = placemarks[0] as! CLPlacemark
                self.displayLocationInfo(pm)
            } else {
                println("Problem with the data received from geocoder")
            }
        })
    }
    
    func displayLocationInfo(placemark: CLPlacemark?) {
        if let containsPlacemark = placemark {
            //stop updating location to save battery life
            locationManager.stopUpdatingLocation()
            let city = (containsPlacemark.locality != nil) ? containsPlacemark.locality : ""
            let postalCode = (containsPlacemark.postalCode != nil) ? containsPlacemark.postalCode : ""
            let state = (containsPlacemark.administrativeArea != nil) ? containsPlacemark.administrativeArea : ""
            let country = (containsPlacemark.country != nil) ? containsPlacemark.country : ""
            let streetNumber = (containsPlacemark.subThoroughfare != nil) ? containsPlacemark.subThoroughfare : ""
            let street = (containsPlacemark.thoroughfare != nil) ? containsPlacemark.thoroughfare : ""
            
            addressLabelField.text = streetNumber + " " + street
            cityLabelField.text = city
            stateLabelField.text = state
            zipLabelField.text = postalCode
        }
        
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error while updating location " + error.localizedDescription)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    func textFieldDidBeginEditing(textField: UITextField) { // became first responder
        //move textfields up
        let myScreenRect: CGRect = UIScreen.mainScreen().bounds
        let keyboardHeight : CGFloat = 200
        
        UIView.beginAnimations( "animateView", context: nil)
        var movementDuration:NSTimeInterval = 0.35
        var needToMove: CGFloat = 0
        
        var frame : CGRect = self.view.frame
        
        if (textField.tag == 3) {
            needToMove = 100
        }
        frame.origin.y = -needToMove
        self.view.frame = frame
        UIView.commitAnimations()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        //move textfields back down
        UIView.beginAnimations( "animateView", context: nil)
        var movementDuration:NSTimeInterval = 0.35
        var frame : CGRect = self.view.frame
        frame.origin.y = 0
        self.view.frame = frame
        UIView.commitAnimations()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addressLabelField.delegate = self
        cityLabelField.delegate = self
        stateLabelField.delegate=self
        zipLabelField.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        // Do any additional setup after loading the view.
    }
    
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.rawValue)
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
