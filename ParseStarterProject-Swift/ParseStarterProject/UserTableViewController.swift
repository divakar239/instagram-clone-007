//
//  UserTableViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Divakar Kapil on 2016-08-01.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class UserTableViewController: UITableViewController {
    
    //MARK: variables 
    
    var usernames = [" "]
    var userIDs = [" "]
    var isFollowing = ["":false] //a dictionary to store if a user is being followed by the current user

    var refresher : UIRefreshControl! // creating a refresh option to refresh feed
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Creation and initiation of the refresher 
        
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string : "Pull To Refresh")
        refresher.addTarget(self, action: #selector(UserTableViewController.refresh), forControlEvents: UIControlEvents.ValueChanged)
        
        self.tableView.addSubview(refresher)
        
        refresh()

        
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
        return usernames.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        cell.textLabel?.text = usernames[indexPath.row]
        
        // if the user in the current row is being followed then keep a checkmark against it
        
        let followedID = userIDs[indexPath.row]
        
        if isFollowing[followedID] == true{
            
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Creating a PFObject of class Followers; setting the properties of this object.
        // Also, creating a checkmark for the rows selected to be followed by the current user.
        
        let following = PFObject(className: "Followers")
        let cell: UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        
        let followedID = userIDs[indexPath.row]
        
        if isFollowing[followedID] == false{
            
        isFollowing[followedID] = true

        cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            
        // assigning the current user, the one who is tapping the rows as the follower
        
        following["Follower"] = PFUser.currentUser()?.objectId
        
        //adding the selected row in the following property to indicate that the current user is following the selected row's user
        
        following["Following"] = userIDs[indexPath.row]
        
        following.saveInBackground()
        }
        
        else{
            
            let followedID = userIDs[indexPath.row]
            
            isFollowing[followedID] == false
            cell.accessoryType = UITableViewCellAccessoryType.None
            
            // creating a query to find the selected row's userID and delete it
            
            var query1 = PFQuery(className: "Followers")
            
            query1.whereKey("Following", equalTo: userIDs[indexPath.row])
            query1.whereKey("Follower", equalTo: (PFUser.currentUser()?.objectId!)!)
            
            query1.findObjectsInBackgroundWithBlock({ (objects, error) in
                
                for object in objects!{
                    
                    object.deleteInBackground()
                    
                }
                
                
                
            })
            
            
        }
        
        
        
        
        
    }
    
    
    // The refresh action
    
    func refresh(){
        
        // Ceating a query for the useIds of all the usernames in Parse database
        
        var query = PFUser.query()
        query?.findObjectsInBackgroundWithBlock({ (objects, error) in
            
            if let users = objects{
                
                // Clearing all the previous data stored in the arrays we created
                
                self.usernames.removeAll(keepCapacity: true)
                self.userIDs.removeAll(keepCapacity: true)
                self.isFollowing.removeAll(keepCapacity: true)
                
                for object in users{
                    
                    
                    if let user = object as? PFUser{
                        
                        // To ensure not to print the name of the current user in the userlist
                        
                        if user.objectId != PFUser.currentUser()?.objectId{
                            
                            self.usernames.append(user.username!)
                            self.userIDs.append(user.objectId!)
                            
                            
                            //Creating a query to find out if the current user is following any users in the database.
                            
                            var query1 = PFQuery(className: "Followers")
                            
                            query1.whereKey("Following", equalTo: user.objectId!)
                            query1.whereKey("Follower", equalTo: (PFUser.currentUser()?.objectId!)!)
                            
                            query1.findObjectsInBackgroundWithBlock({ (objects, error) in
                                
                                if let objects = objects{
                                    
                                    if objects.count > 0{
                                        
                                        self.isFollowing[user.objectId!] = true
                                        
                                    }
                                        
                                    else{
                                        
                                        self.isFollowing[user.objectId!] = false
                                    }
                                }
                                
                                if self.isFollowing.count == self.userIDs.count{
                                    
                                    self.tableView.reloadData()
                                    self.refresher.endRefreshing()
                                    
                                }
                                
                            })
                        }
                    }
                    
                }
                
            }
            
            
        })
     
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
