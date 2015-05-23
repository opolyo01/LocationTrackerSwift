//
//  InfoViewController.swift
//  Location
//
//  Created by Oleg Polyakov on 5/22/15.
//  Copyright (c) 2015 Oleg Polyakov. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    var selectedLocation:AnyObject = ""
    
    
    @IBOutlet weak var addressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let address:String = (selectedLocation.valueForKey("address") as? String)!
        let city:String = (selectedLocation.valueForKey("city") as? String)!
        let state:String = (selectedLocation.valueForKey("state") as? String)!
        addressLabel.text = address + " " + city + " " + state
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
