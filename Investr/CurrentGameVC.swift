//
//  CurrentGameVC.swift
//  Investr
//
//  Created by Timothy Huesmann on 9/14/15.
//  Copyright (c) 2015 Timothy Huesmann. All rights reserved.
//

import UIKit
import Parse

class CurrentGameVC: UIViewController {

    @IBOutlet weak var StockTV: UITableView!
    @IBOutlet weak var gameName: UILabel!
    @IBOutlet weak var wallet: UILabel!
    @IBOutlet weak var sellButton: UIButton!
    var tempName : String!
    var stocksNum : Int!
    var stocks = [String]()
    var tempEnd = NSDate()
    var tempWallet : Double!
    var tempID : String!
    var tempStock : NSDictionary!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBAction func buyButtonPressed(sender: AnyObject)
    {
        
    }
    
    @IBAction func sellButtonPressed(sender: AnyObject)
    {
        
    }
    
    func getStocks()
    {
        let query = PFQuery(className: "Transaction")
        query.whereKey("GameID", equalTo: PFObject(withoutDataWithClassName: "Game", objectId: self.tempID))
        query.whereKey("userName", equalTo: InvestrCore.currUser)
        query.findObjectsInBackgroundWithBlock
        {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil
            {
                if let objects = objects
                {
                    if objects[0]["stocksInHand"] != nil
                    {
                        self.stocksNum = objects[0]["stocksInHand"].count
                        for(var i = 0; i < self.stocksNum;i++)
                        {
                            self.tempStock = objects[0]["stocksInHand"][i] as! NSDictionary
                            let tempNumStock =  self.tempStock["share"] as! NSString
                            let tempStockName = self.tempStock["symbol"] as! NSString
                            self.stocks.append("\(tempStockName)  -   \(tempNumStock)")
                            
                        }
                    }
                    else
                    {
                        self.stocksNum = 0
                        self.stocks = []
                    }
                }
                self.StockTV.reloadData()
            }
            else
            {
                print("Error: \(error) \(error!.userInfo)")
            }
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.gameName.text = tempName
        self.wallet.text = "$ \(self.tempWallet)"
        self.dateLabel.text = "\(self.tempEnd)"
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setGame(name: String, end: NSDate, userWallet: Double, gameID: String)
    {
        tempName = name
        tempEnd = end
        tempWallet = userWallet
        tempID = gameID
        self.stocksNum = 0
    }
    

    
    // MARK: - Navigation

    
    func tableView(tableView: UITableView,
        titleForHeaderInSection section: Int) -> String?
    {
        return "Owned Stocks"
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
        return stocksNum
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        // Configure the cell...
        cell.textLabel!.text = self.stocks[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath!)
    {
        
        
    }
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
