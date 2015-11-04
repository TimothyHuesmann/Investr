//
//  GameStandingsTVC.swift
//  Investr
//
//  Created by Timothy Huesmann on 11/2/15.
//  Copyright © 2015 Timothy Huesmann. All rights reserved.
//

import UIKit
import Parse

class GameStandingsTVC: UIViewController, Observable
{
    
    @IBOutlet weak var standingsTV: UITableView!
    var names = [String]()
    var wallets = [Double]()
    var gameID: String!
    
    func getStandings(gameID: String)
    {
        self.gameID = gameID
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        InvestrCore.tempString.addObserver(self)
        InvestrCore.getStandings(gameID)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
        return self.names.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! GameStandingsTVCell
        
        // Configure the cell...
        cell.username.text = self.names[indexPath.row]
        cell.wallet.text = "\(self.wallets[indexPath.row])"
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath!)
    {
        
    }
    
    func observableStringUpdate(newValue: String, identifier: String)
    {
        self.standingsTV.reloadData()
        print(self.names)
        print(self.wallets)
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
