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

class GamesListTVC: UIViewController
{
    @IBOutlet weak var upcomingGamesTV: UITableView!
    var currentUser = PFUser.currentUser()
    var upcomingGamesnum = 0
    var playingGamesnum = 0
    var upcomingGames = [String]()
    var playingGames = [String]()
    var numPlayers = 0
    var potSize = 0
    var price = 0.0
    var tempID = ""
    
    
    
    func firstGamesQuery()          //query of games that are not yet running
    {
        let query = PFQuery(className: "Game")
        query.whereKey("Playing", equalTo:false)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects
                {
                    self.upcomingGamesnum = objects.count
                    for object in objects
                    {
                        self.upcomingGames.append(object["Name"]! as! String)
                    }
                    self.upcomingGamesTV.reloadData()
                }
            }
            else
            {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
       
        let query2 = PFQuery(className: "Game")
        query2.whereKey("Playing", equalTo:true)
        query2.findObjectsInBackgroundWithBlock {
            (objects2: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil{
                if let objects2 = objects2
                {
                    self.playingGamesnum = objects2.count
                    for object2 in objects2
                    {
                        self.playingGames.append(object2["Name"]! as! String)
                    }
                    self.upcomingGamesTV.reloadData()
                }
            }
            else
            {
                print("Error: \(error!) \(error!.userInfo)")
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
    
    func tableView(tableView: UITableView,
        titleForHeaderInSection section: Int) -> String?
    {
        if(section == 0)
        {
            return "Running Games"
        }
        else
        {
            return "Upcoming Games"
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        if(section == 0)
        {
            return playingGamesnum
        }
        else
        {
            return upcomingGamesnum
        }
        
       
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) 
        
        // Configure the cell...
        if(indexPath.section == 0)
        {
            cell.textLabel!.text = self.playingGames[indexPath.row] //display upcoming games
        }
        else
        {
            cell.textLabel!.text = self.upcomingGames[indexPath.row] //display currently running games
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath!)
    {
        
        let indexPath = tableView.indexPathForSelectedRow
        let currentCell = tableView.cellForRowAtIndexPath(indexPath!) as UITableViewCell!
        let query = PFQuery(className: "Game")
        print(currentCell.textLabel!.text!, terminator: "")
        query.whereKey("Name", equalTo: currentCell.textLabel!.text!)
        query.findObjectsInBackgroundWithBlock
        {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil
            {
                //the find succeeded
                //print("Successfully found \(objects!.count) Games")
                if let objects = objects
                {
                    self.tempID = objects[0].objectId!
                    if objects[0]["CurrentPlayers"] != nil
                    {
                        self.numPlayers = objects[0]["CurrentPlayers"]!.count     //setting the number of players label
                    }
                    else
                    {
                        self.numPlayers = 0
                    }
                    
                    if objects[0]["PotSize"] != nil
                    {
                        self.potSize = objects[0]["PotSize"]! as! Int   //setting the potSize label
                    }
                    else
                    {
                        self.potSize = 0
                    }
                    self.price = objects[0]["Price"]! as! Double    //setting the price label
                    let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("PlannedGameVC") as! PlannedGameVC
                    
                    viewController.setGameInfo(currentCell.textLabel!.text!, numPlayers: self.numPlayers, potSize: self.potSize, price: self.price, gameID: self.tempID)
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
                    
            }
            else
            {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
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

