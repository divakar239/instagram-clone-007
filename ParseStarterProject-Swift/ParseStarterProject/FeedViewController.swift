//
//  FeedViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Divakar Kapil on 2016-08-06.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class FeedViewController: UITableViewController {
    
    // MARK: arrays and variables
    
    var userNames = [String]()
    var messages = [String]()
    var imageFiles = [PFFile]()
    var users = [String:String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Step 1: fetching all the users to ontain the usernmaes from the userIds
        
        let query = PFUser.query()
        query?.findObjectsInBackgroundWithBlock({ (objects, error) in
            
            if let users = objects{
                
                // Clearing all the previous data stored in the arrays we created
                
                self.userNames.removeAll(keepCapacity: true)
                self.messages.removeAll(keepCapacity: true)
                self.imageFiles.removeAll(keepCapacity: true)
                self.users.removeAll(keepCapacity: true)
                
                for object in users{
                    
                    if let user = object as? PFUser{
                        
                        // To ensure not to print the name of the current user in the userlist
                        
                        if user.objectId != PFUser.currentUser()?.objectId{
                            
                          self.users[user.objectId!] = user.username
                        }
                    
                    }
        
        
                }
            }
        })
        // Step 2: fetching the users that are being followed by the current user
        
        
        let getFollwingUsersQuery = PFQuery(className: "Followers")
        getFollwingUsersQuery.whereKey("Follower", equalTo: PFUser.currentUser()!.objectId!)
        
        getFollwingUsersQuery.findObjectsInBackgroundWithBlock { (objects, error) in
            
            if let objects = objects{
                
                for object in objects{
                    
                    let followedUser = object["Following"] as! String
                    
                    
                    
                    // Step 3: Querying all the posts made by the user that the current user is following.
                    
                    let query = PFQuery(className: "Post")
                    query.whereKey("userId", equalTo: followedUser)
                    
                    query.findObjectsInBackgroundWithBlock({ (objects, error) in
                        
                        if let objects = objects{
                            
                            
                            for object in objects{
                                
                                
                                self.messages.append(object["message"] as! String)
                                self.imageFiles.append(object["imageFile"] as!PFFile)
                                self.userNames.append(self.users[object["userId"] as! String]!)
                                
                                self.tableView.reloadData()
                                
                            }
                            
                        }
                        
                    })
                }
                
            }
            
            
        }
        
        
        
        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userNames.count
    }

    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! Cell

        // Downloading Images
        
       imageFiles[indexPath.row].getDataInBackgroundWithBlock { (data, error) in
            
            
            if let downloadedImage = UIImage(data: data!){
                
                myCell.postedImage.image = downloadedImage
            }
        }
        
        
       
        
        myCell.userName.text = userNames[indexPath.row]
        myCell.message.text = messages[indexPath.row]
        
        
        return myCell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
