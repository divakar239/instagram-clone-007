//
//  PostImageViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Divakar Kapil on 2016-08-03.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class PostImageViewController: UIViewController, UINavigationControllerDelegate,UIImagePickerControllerDelegate {

    //MARK: Outlets and actions
    
    //Activity Indicator
    
    var activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet weak var imageToPost: UIImageView!
    
    @IBAction func chooseImage(sender: AnyObject) {
        
        // Choosing Image from the photo stream
        
        // so basically we set the 1. delegate  2. source 3. editing permission 4. present the view controller after we create the UIImagePickerController object.
        
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        
        self.presentViewController(image, animated: true, completion: nil)
        
    }
    
       @IBOutlet weak var message: UITextField!
    
    
    @IBAction func postImage(sender: AnyObject) {
        
        
        
        activityIndicator = UIActivityIndicatorView(frame: self.view.frame)
        activityIndicator.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        var post = PFObject(className: "Post")
        
        post["message"] = message.text
        
        post["userId"] = PFUser.currentUser()!.objectId!
        
        let imageData = UIImagePNGRepresentation(imageToPost.image!)
        
        let imageFile = PFFile(name: "image.png", data: imageData!)
        
        post["imageFile"] = imageFile
        
        
       post.saveInBackgroundWithBlock{(success, error) -> Void in
        
        print("Hi")
        
            self.activityIndicator.stopAnimating()
            
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            if error == nil {
                
                self.displayAlert("Image Posted!", message: "Your image has been posted successfully")
                
                self.imageToPost.image = UIImage(named: "placeholder.png")
                
                self.message.text = ""
                
                print("Hi")
                
            } else {
                
                self.displayAlert("Could not post image", message: "Please try again later")
                
            }
            
        }
        
    }

    
  /*  @IBAction func postImage(sender: AnyObject) {
        
        // setting up the activity Indicator
        
        activityIndicator = UIActivityIndicatorView(frame : self.view.frame)
        activityIndicator.backgroundColor = UIColor(white : 1.0 , alpha: 0.5)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        // We are creating a class and it's properties on the fly.
        
        let post = PFObject(className :"Post")
        post["message"] = message.text
        post["userID"] = PFUser.currentUser()!.objectId!
        
        // To create the image property we need to convert the image into data and store it into a file in the Parse database
        
        let imageData = UIImagePNGRepresentation(imageToPost.image!)
        let imageFile = PFFile(name: "image.png", data: imageData!)
        
        post["imageFile"] = imageFile
        
        post.saveInBackgroundWithBlock { (success, error) in
            
            // Once the posting is succeful, we can remove the activityIndicator
            
            self.activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            
            if error == nil{
                
                self.displayAlert("Image Posted", message: "Your image has been posted succesfully")
                self.imageToPost.image = UIImage(named: "placeholder.png")
                self.message.text = ""
                
            }
            else{
                
                self.displayAlert("Your Image", message: "Your image was not succefully posted")
                
            }
        }
        
    }*/
    
    //display Alert method
    
    func displayAlert(title: String,message: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: { (action) in
            self.dismissViewControllerAnimated(true, completion: nil)
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }


    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

        // This method is necessary to implement the UIImagePickerControllerDelegate. It informs the delegate that the user picked up an image.
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        imageToPost.image = image
        
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
