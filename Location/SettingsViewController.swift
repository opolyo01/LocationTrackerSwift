//
//  SettingsViewController.swift
//  Location
//
//  Created by Oleg Polyakov on 5/20/15.
//  Copyright (c) 2015 Oleg Polyakov. All rights reserved.
//

import UIKit
import MessageUI

class SettingsViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    var settings = Settings()
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    @IBOutlet weak var locationUpdates: UISwitch!
    
    @IBAction func updateLocationChanged(sender: UISwitch) {
        settings.updatesOn = sender.on
    }
    
    
    @IBAction func shareLocations(sender: AnyObject) {
        var emailTitle = "My Favorite Locations"
        var messageBody = ""
        //var toRecipents = ["friend@stackoverflow.com"]
        var mc: MFMailComposeViewController = MFMailComposeViewController()
        mc.mailComposeDelegate = self
        mc.setSubject(emailTitle)
        
        //mc.setToRecipients(toRecipents)
        
        let locations = Location.fetchLocations(managedObjectContext!)
        println("Total count of locations \(locations.count)")
        for location in locations{
            let address = location.valueForKey("address") as! String
            let city = location.valueForKey("city") as! String
            let state = location.valueForKey("state") as! String
            let zipCode = location.valueForKey("zipCode") as! String
            let addressLine = address + " " + city + " " + state + " " + zipCode
            let link = "<a href='http://maps.apple.com/?daddr=\(addressLine)&saddr=Current%%20Location'>\(addressLine)</a>"
            messageBody  = messageBody + link + "<br/><br/>"
        }
        mc.setMessageBody(messageBody, isHTML: true)
        self.presentViewController(mc, animated: true, completion: nil)
    }
    
    func mailComposeController(controller:MFMailComposeViewController, didFinishWithResult result:MFMailComposeResult, error:NSError) {
        switch result.value {
        case MFMailComposeResultCancelled.value:
            println("Mail cancelled")
        case MFMailComposeResultSaved.value:
            println("Mail saved")
        case MFMailComposeResultSent.value:
            println("Mail sent")
        case MFMailComposeResultFailed.value:
            println("Mail sent failure: %@", [error.localizedDescription])
        default:
            break
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settings = (tabBarController as! LocationTabBarControllerViewController).settings
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
