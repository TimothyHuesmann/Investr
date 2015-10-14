//
//  GameHistoryTVC.swift
//  Investr
//
//  Created by Timothy Huesmann on 10/14/15.
//  Copyright © 2015 Timothy Huesmann. All rights reserved.
//

import UIKit
import Parse

class GameHistoryTVC: UIViewController
{
    
    @IBOutlet weak var theGamesTV: UITableView!
    var theGames = [GameRecord]()
    
    override func viewDidLoad()
    {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func queryGames()
    {
        let query = PFQuery(className: "Game")
        query.whereKey("Playing", equalTo: false)
        query.whereKey("isFinished", equalTo: true)
        query.whereKey("CurrentPlayers", equalTo:InvestrCore.currUser)
        query.findObjectsInBackgroundWithBlock
        {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if(error == nil)
            {
                if let objects = objects
                {
                    print("Successfully found \(objects.count) games")
                    for(var i = 0; i<objects.count;i++)
                    {
                        self.theGames.append(GameRecord(name: objects[i]["Name"] as! String, numPlayers: objects[i]["CurrentPlayers"].count, pot: objects[i]["PotSize"] as! Double, end: objects[i]["EndTime"] as! NSDate, place: objects[i]["finalStandings"].indexOfObjectIdenticalTo(InvestrCore.currUser)+1))
                    }
                    self.theGamesTV.reloadData()
                }
            }
            else
            {
                
            }
                
        }
    }
    
    
    
    //UnComment  if we need to manipulate the title of the TV
    
    /*
    func tableView(tableView: UITableView,
    titleForHeaderInSection section: Int) -> String?
    {
    return "Owned Stocks"
    }
    */
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.theGames.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! GameRecordTVCell
        
        // Configure the cell...
        cell.gameNameLabel.text = theGames[indexPath.row].name
        cell.placeLabel.text = "Place: \(theGames[indexPath.row].place)"
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath!)
    {
        
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
