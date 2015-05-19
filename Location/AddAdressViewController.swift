//
//  AddAdressViewController.swift
//  Location
//
//  Created by Oleg Polyakov on 5/18/15.
//  Copyright (c) 2015 Oleg Polyakov. All rights reserved.
//

import UIKit
import CoreData

class AddAdressViewController: UIViewController {
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    @IBOutlet weak var addressLabelField: UITextField!
    
    @IBOutlet weak var cityStateZipLabelField: UITextField!
    
    @IBAction func setCurrentLocation(sender: AnyObject) {
        
    }
    
    
    @IBAction func addAddress(sender: AnyObject) {
        Location.addLocation(managedObjectContext!, address: addressLabelField.text, cityStateZip: cityStateZipLabelField.text)
        navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
