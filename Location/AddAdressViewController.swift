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
    

    @IBOutlet weak var addressLabelField: UITextField!
    
    @IBOutlet weak var cityStateZipLabelField: UITextField!
    
    @IBAction func setCurrentLocation(sender: AnyObject) {
        
    }
    
    
    @IBAction func addAddress(sender: AnyObject) {
//        let appDelegate =
//        UIApplication.sharedApplication().delegate as! AppDelegate
//        
//        let managedContext = appDelegate.managedObjectContext!
//        
//        //2
//        let entity =  NSEntityDescription.entityForName("Person",
//            inManagedObjectContext:
//            managedContext)
//        
//        let person = NSManagedObject(entity: entity!,
//            insertIntoManagedObjectContext:managedContext)
//        
//        //3
//        person.setValue(name, forKey: "name")
//        
//        //4
//        var error: NSError?
//        if !managedContext.save(&error) {
//            println("Could not save \(error), \(error?.userInfo)")
//        }
//        //5
//        people.append(person)

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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
