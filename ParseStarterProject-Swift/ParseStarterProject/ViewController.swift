/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

class ViewController: UIViewController {
    
    var activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView()
    var signUpActive = true
    
    // MARK : IBOutlets and IBActions
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signupOutlet: UIButton!
    @IBOutlet weak var regesteredText: UILabel!
    
    @IBOutlet weak var loginOutlet: UIButton!
    
    var errorMessage = "Please try again later"
    
    @IBAction func signUp(sender: AnyObject) {
        
        if username.text == "" || password.text == ""{
            
                displayAlert("Error in Form", message: "Please fill in a valid username and password")
        
        }
        
        else{
            
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0,0,50,50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            // Code for sign up
            
            if signUpActive == true{
            let user = PFUser()
            user.username = username.text
            user.password = password.text
            
            user.signUpInBackgroundWithBlock({ (success, error) in
                
                self.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                if error == nil{
                    
                    self.performSegueWithIdentifier("login", sender: self)
                    
                }
                
                else{
                    
                    if let errorString = error!.userInfo["error"] as? String{
                        
                        self.errorMessage = errorString
                        self.displayAlert("Failed Signup", message: "errorMessage")
                        
                    }
                    
                }
                
            })
                           
        }
            
            else{
                
                PFUser.logInWithUsernameInBackground(username.text!, password: password.text!, block: { (user, error) in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                    if user != nil{
                        
                        //successfully logged in
                    }
                    
                    else{
                        
                        if let errorString = error!.userInfo["error"] as? String{
                            
                            self.errorMessage = errorString
                            self.displayAlert("Failed Login", message: "errorMessage")
                            
                        }
                        
                    }
                })
                
                
            }
    }
        
}
   
    // Login function
    @IBAction func login(sender: AnyObject) {
        
        if signUpActive == true{
        
            signupOutlet.setTitle("Login", forState: .Normal)
            loginOutlet.setTitle("Sign Up", forState: .Normal)
            regesteredText.text = "Not Regestered !"
            
            signUpActive = false
        }
        
        else{
            
            signupOutlet.setTitle("Sign Up", forState: .Normal)
            loginOutlet.setTitle("Login", forState: .Normal)
            regesteredText.text = "Already Regestered"
            
            signUpActive = true
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
        
    }
    
    
    //adding code to jump to the login segue if the user is alreday logegd in
    
    override func viewDidAppear(animated: Bool) {
        
        if PFUser.currentUser() != nil{
            
            self.performSegueWithIdentifier("login", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    // Function to create Alerts
    
    func displayAlert(title: String,message: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: { (action) in
            self.dismissViewControllerAnimated(true, completion: nil)
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
}
