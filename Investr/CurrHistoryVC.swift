//
//  CurrHistoryVC.swift
//  Investr
//
//  Created by Timothy Huesmann on 10/12/15.
//  Copyright © 2015 Timothy Huesmann. All rights reserved.
//

import UIKit
import Parse

class CurrHistoryVC: UIViewController
{
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var historyTVC: UITableView!
    var gameID: String!
    var theTransactions = [Transaction]()
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        if self.revealViewController() != nil
        {
            self.menuButton.target = self.revealViewController()
            self.menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getHistory()
    {
        let query = PFQuery(className: "Transaction")
        query.whereKey("userName", equalTo: InvestrCore.currUser)
        query.whereKey("GameID", equalTo: PFObject(withoutDataWithClassName: "Game", objectId: self.gameID))
        query.findObjectsInBackgroundWithBlock
            {
                (objects: [PFObject]?, error: NSError?) -> Void in
                if(error == nil)
                {
                    if let objects = objects
                    {
                        if(objects[0]["log"] != nil)
                        {
                            for(var i = 0; i < objects[0]["log"].count; i++)
                            {
                                let logString = objects[0]["log"][i]
                                var tempVal = logString["operation"]!!.componentsSeparatedByString("-")
                                print(tempVal)
                                var tempTime: NSString!
                                tempTime = logString["time"] as! NSString
                                print(tempTime!)
                                if(tempVal[0] == "join")
                                {
                                    self.theTransactions.append(Transaction(type: "Joined the Game", ticker: "", value: "", date: logString["time"] as! String, amount: ""))
                                }
                                else if(tempVal[0] == "checkout")
                                {
                                    self.theTransactions.append(Transaction(type: "Game End", ticker: "", value: "", date: logString["time"] as! String, amount: ""))
                                }
                                else
                                {
                                    self.theTransactions.append(Transaction(type: tempVal[0], ticker: tempVal[1], value: tempVal[2], date: logString["time"] as! String, amount: tempVal[3]))
                                }
                                
                            }
                        }
                        else
                        {
                            
                        }
                        
                    }
                    self.historyTVC.reloadData()
                }
                else
                {
                    print("Error: \(error) \(error!.userInfo)")
                }
                
        }
    }
    
    func setUp(gameID: String)
    {
        self.gameID = gameID
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
        return self.theTransactions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TransTVCell
        
        // Configure the cell...
        cell.typeLabel.text = self.theTransactions[indexPath.row].type.uppercaseString
        cell.numLabel.text = self.theTransactions[indexPath.row].value
        cell.tickerLabel.text = self.theTransactions[indexPath.row].ticker.uppercaseString
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath!)
    {
        let historyVC = self.storyboard?.instantiateViewControllerWithIdentifier("HistoryVC") as! HistoryVC
        historyVC.getInfo(theTransactions[indexPath.row])
        self.navigationController?.pushViewController(historyVC, animated: true)
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
