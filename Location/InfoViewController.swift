//
//  InfoViewController.swift
//  Location
//
//  Created by Oleg Polyakov on 5/22/15.
//  Copyright (c) 2015 Oleg Polyakov. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices

class InfoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var selectedLocation:AnyObject = ""
    
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var postImage: UIImageView!
    
    
    @IBAction func selectImage(sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType =
            UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.mediaTypes = [kUTTypeImage as NSString]
        imagePicker.allowsEditing = false
        self.presentViewController(imagePicker, animated: true,
            completion: nil)
    }
    
    
    @IBAction func sendPost(sender: AnyObject) {
        var activityItems: [AnyObject]?
        let image = postImage.image
        let textToPost = addressLabel.text!
        
        if (postImage.image != nil) {
            activityItems = [textToPost, postImage.image!]
        } else {
            activityItems = [textToPost]
        }
        
        let activityController = UIActivityViewController(activityItems:
            activityItems!, applicationActivities: nil)
        self.presentViewController(activityController, animated: true,
            completion: nil)
    }
    
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
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
            self.dismissViewControllerAnimated(true, completion: nil)
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            postImage.image = image
    }
    
    func imagePickerControllerDidCancel(picker:
        UIImagePickerController) {
            self.dismissViewControllerAnimated(true, completion: nil)
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
