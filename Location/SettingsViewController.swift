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
        let emailTitle = "My Favorite Locations"
        var messageBody = ""
        //var toRecipents = ["friend@stackoverflow.com"]
        let mc: MFMailComposeViewController = MFMailComposeViewController()
        mc.mailComposeDelegate = self
        mc.setSubject(emailTitle)
        
        //mc.setToRecipients(toRecipents)
        
        let locations = Location.fetchLocations(managedObjectContext!)
        print("Total count of locations \(locations.count)", appendNewline: false)
        for location in locations{
            let address = location.valueForKey("address") as! String
            let city = location.valueForKey("city") as! String
            let state = location.valueForKey("state") as! String
            let zipCode = location.valueForKey("zipCode") as! String
            let addressLine = address + " " + city + " " + state + " " + zipCode
            let link = "<a href='http://maps.apple.com/?daddr=\(addressLine)&saddr=Current Location'>\(addressLine)</a>"
            messageBody  = messageBody + link + "<br/><br/>"
        }
        mc.setMessageBody(messageBody, isHTML: true)
        self.presentViewController(mc, animated: true, completion: nil)
    }
    
    func mailComposeController(controller:MFMailComposeViewController, didFinishWithResult result:MFMailComposeResult, error:NSError?) {
        switch result.rawValue {
        case MFMailComposeResultCancelled.rawValue:
            print("Mail cancelled", appendNewline: false)
        case MFMailComposeResultSaved.rawValue:
            print("Mail saved", appendNewline: false)
        case MFMailComposeResultSent.rawValue:
            print("Mail sent", appendNewline: false)
        case MFMailComposeResultFailed.rawValue:
            print("Mail sent failure: %@", [error!.localizedDescription], appendNewline: false)
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
