//
//  GamesListTVC.swift
//  Investr
//
//  Created by Timothy Huesmann on 9/2/15.
//  Copyright (c) 2015 Timothy Huesmann. All rights reserved.
//


import UIKit
import Parse


protocol GamesListTVCDelegate
{
    func VCDidFinish(controller:GamesListTVC)
}

class GamesListTVC: UIViewController {
    
    
    @IBAction func switchPressed(sender: AnyObject)
    {
        self.upcomingGamesTV.reloadData()
    }
    
    @IBOutlet weak var tableViewSwitch: UISegmentedControl!
    @IBOutlet weak var upcomingGamesTV: UITableView!
    var currentUser = PFUser.currentUser()
    var upcomingGamesnum = 0
    var playingGamesnum = 0
    var upcomingGames = [String]()
    var playingGames = [String]()
    
    
    
    func firstGamesQuery()          //query of games that are not yet running
    {
        var query = PFQuery(className: "Game")
        query.whereKey("Playing", equalTo:false)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                println("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    self.upcomingGamesnum = objects.count
                    for object in objects
                    {
                        self.upcomingGames.append(object["Name"]! as! String)
                    }
                    self.upcomingGamesTV.reloadData()
                }
            } else {
                // Log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
            }
        }
        var query2 = PFQuery(className: "Game")       //query of games that are running and the user is in
        query2.whereKey("Playing", equalTo:true)
        query2.whereKey("CurrentPlayers", equalTo:InvestrCore.currUser)
        query2.findObjectsInBackgroundWithBlock {
            (objects2: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                println("Successfully retrieved \(objects2!.count) scores.")
                // Do something with the found objects
                if let objects2 = objects2 as? [PFObject] {
                    self.playingGamesnum = objects2.count
                    for object2 in objects2
                    {
                        self.playingGames.append(object2["Name"]! as! String)
                    }
                }
            } else {
                // Log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        firstGamesQuery()  //calls both queries
        self.upcomingGamesTV.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        if(self.tableViewSwitch.selectedSegmentIndex == 0)
        {
            return upcomingGamesnum
        }
        else
        {
            return playingGamesnum
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        
        // Configure the cell...
        if(self.tableViewSwitch.selectedSegmentIndex == 0)
        {
            cell.textLabel!.text = self.upcomingGames[indexPath.row] //display upcoming games
        }
        else
        {
            cell.textLabel!.text = self.playingGames[indexPath.row]  //display my games
        }
        
        return cell
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the specified item to be editable.
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
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
}
