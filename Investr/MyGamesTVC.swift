//
//  MyGamesTVC.swift
//  Investr
//
//  Created by Timothy Huesmann on 9/14/15.
//  Copyright (c) 2015 Timothy Huesmann. All rights reserved.
//

import UIKit
import Parse

class MyGamesTVC: UIViewController {

    @IBOutlet weak var theGamesTV: UITableView!
    var playingGamesnum = 0
    var playingGames = [String]()
    var myUpcomingGamesnum = 0
    var myUpcomingGames = [String]()
    var endGame = ""
    var tempID = ""
    var tempWallet = 0.0
    var tempStocks = [String]()
    
    func gamesQuery()
    {
        let query2 = PFQuery(className: "Game")       //query of games that are running and the user is in
        query2.whereKey("Playing", equalTo:true)
        query2.whereKey("CurrentPlayers", equalTo:InvestrCore.currUser)
        query2.findObjectsInBackgroundWithBlock {
            (objects2: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects2!.count) scores.")
                // Do something with the found objects
                if let objects2 = objects2  {
                    self.playingGamesnum = objects2.count
                    for object2 in objects2
                    {
                        self.playingGames.append(object2["Name"]! as! String)
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        
        let query = PFQuery(className: "Game")
        query.whereKey("Playing", equalTo:false)
        query.whereKey("CurrentPlayers", equalTo:InvestrCore.currUser)
        query.findObjectsInBackgroundWithBlock{
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil{
                if let objects = objects
                {
                    self.myUpcomingGamesnum = objects.count
                    for object in objects
                    {
                        self.myUpcomingGames.append(object["Name"]! as! String)
                    }
                }
                else
                {
                    print("Error: \(error!) \(error!.userInfo)")
                }
            }
        }
        
        
        
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

    func tableView(tableView: UITableView,
        titleForHeaderInSection section: Int) -> String?
    {
        if(section == 0)
        {
            return "My Running Games"
        }
        else
        {
            return "My Upcoming Games"
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 2
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if(section == 0)
        {
            return playingGamesnum
        }
        else
        {
            return myUpcomingGamesnum
        }
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) 

        // Configure the cell...
        if(indexPath.section == 0)
        {
            cell.textLabel!.text = self.playingGames[indexPath.row]
        }
        else
        {
            cell.textLabel!.text = self.myUpcomingGames[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath!)
    {
        let indexPath = tableView.indexPathForSelectedRow
        let currentCell = tableView.cellForRowAtIndexPath(indexPath!) as UITableViewCell!
        let query3 = PFQuery(className: "Games")
        query3.whereKey("Name", equalTo: currentCell.textLabel!.text!)
        query3.findObjectsInBackgroundWithBlock
        {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil
            {
                if let objects = objects
                {
                    self.endGame = objects[0]["EndTime"] as! String
                    self.tempID = objects[0].objectId!
                }
            }
            else
            {
                print("Error: \(error) \(error!.userInfo)")
            }
            let query4 = PFQuery(className: "Transaction")
            query4.whereKey("GameID", equalTo: self.tempID)
            query4.whereKey("userName", equalTo: InvestrCore.currUser)
            query4.findObjectsInBackgroundWithBlock
            {
                (objects2: [PFObject]?, error: NSError?) -> Void in
                if error == nil
                {
                    if let objects2 = objects2
                    {
                        self.tempWallet = objects2[0]["Wallet"] as! Double
                        self.tempStocks = objects2[0]["stocksInHand"] as! [String]
                    }
                    let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("CurrentGameVC") as! CurrentGameVC
                    viewController.setGame(currentCell.textLabel!.text!, end: "")
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
                else
                {
                    print("Error: \(error) \(error!.userInfo)")
                }
                
            }
        }
        
        
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
