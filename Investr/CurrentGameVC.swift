//
//  CurrentGameVC.swift
//  Investr
//
//  Created by Timothy Huesmann on 9/14/15.
//  Copyright (c) 2015 Timothy Huesmann. All rights reserved.
//

import UIKit
import Parse

class CurrentGameVC: UIViewController, Observable {

    
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var portfolioWorthAIV: UIActivityIndicatorView!
    @IBOutlet weak var currentStocksAIV: UIActivityIndicatorView!
    @IBOutlet weak var portfolioWorthLabel: UILabel!
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var hiddenLabel: UILabel!
    @IBOutlet weak var StockTV: UITableView!
    @IBOutlet weak var wallet: UILabel!
    var tempName : String!
    var stocksNum : Int!
    var stocks: NSMutableArray = []
    var tempEnd = NSDate()
    var tempID : String!
    var tempStock : NSDictionary!
    var stockNames = [String]()
    var transID: String!
    var shortDate: String!
    var timer: NSTimer!
    var refresher: UIRefreshControl!
    var tempVar: Int!
    @IBOutlet weak var dateLabel: UILabel!

    @IBAction func tempLookupButtonPressed(sender: AnyObject)
    {
        let lookupStockVC = self.storyboard?.instantiateViewControllerWithIdentifier("LookupStockVC") as! LookupStockVC
        lookupStockVC.getInfo(self.tempID)
        self.navigationController?.pushViewController(lookupStockVC, animated: true)
    }
    
    @IBAction func leaderboardButtonPressed(sender: AnyObject)
    {
        let gameStandingsTVC = self.storyboard?.instantiateViewControllerWithIdentifier("GameStandingsTVC") as! GameStandingsTVC
        gameStandingsTVC.getStandings(self.tempID)
        self.navigationController?.pushViewController(gameStandingsTVC, animated: true)
    }
    
    @IBAction func refreshButtonPressed(sender: AnyObject)
    {
        autoRefresh()
    }
    
    func autoRefresh()
    {
        self.tempVar = 2
        self.StockTV.reloadData()
        self.portfolioWorthAIV.startAnimating()
        self.portfolioWorthLabel.text = "Calculating Portfolio Value"
        InvestrCore.getPortfolio(InvestrCore.transactionID.value, portfolioLabel: self.portfolioWorthLabel, spinner: self.portfolioWorthAIV)
        InvestrCore.currentGame(InvestrCore.transactionID.value, array: self.stocks)
        self.currentStocksAIV.startAnimating()
    }
    
    @IBAction func historyButtonPressed(sender: AnyObject)
    {
        let currHistoryVC = self.storyboard?.instantiateViewControllerWithIdentifier("CurrHistoryVC") as! CurrHistoryVC
        currHistoryVC.setUp(self.tempID)
        currHistoryVC.navigationController?.title = "Transaction History"
        currHistoryVC.getHistory()
        self.navigationController?.pushViewController(currHistoryVC, animated: true)
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
                        InvestrCore.transactionID.updateValue(objects[0].objectId!)
                    }
                    self.StockTV.reloadData()
                
                }
                else
                {
                    print("Error: \(error) \(error!.userInfo)")
                }
            }
        }
    }
    
    
    
    func observableStringUpdate(newValue: String, identifier: String)
    {
        print("I received \(newValue) for variable: \(identifier)")
        if(identifier == "buyStock")
        {
            let tempVal = newValue.componentsSeparatedByString("-")
            var tempIndex = 0
            var found = false
            for stock in self.stocks
            {
                var i = 0
                if (stock as! Stock).name == tempVal[0]
                {
                    tempIndex = i
                    if InvestrCore.selling == false
                    {
                        (self.stocks.objectAtIndex(tempIndex) as! Stock).value = (self.stocks.objectAtIndex(tempIndex) as! Stock).value + (Int(tempVal[1])!)
                    }
                    else
                    {
                        (self.stocks.objectAtIndex(tempIndex) as! Stock).value = (self.stocks.objectAtIndex(tempIndex) as! Stock).value - (Int(tempVal[1])!)
                        if((self.stocks.objectAtIndex(tempIndex) as! Stock).value == 0)
                        {
                            self.stocks.removeObjectAtIndex(tempIndex)
                        }
                    }
                    self.tempVar = 1
                    
                    found = true
                }
                i++
            }
            if(found == false && InvestrCore.selling == false)
            {
                self.stocks.addObject(Stock(name: tempVal[0], value: (Int(tempVal[1])!), change: 0, buyVal: 0, bidVal: 0))
                self.tempVar = 1
            }
            self.StockTV.reloadData()
            
        }
        
        
        if(identifier == "transactionID")
        {
            InvestrCore.getPortfolio(newValue, portfolioLabel: self.portfolioWorthLabel, spinner: self.portfolioWorthAIV)
            InvestrCore.currentGame(newValue, array: self.stocks)
        }
        
        
        if(identifier == "wallet")
        {
           self.wallet.text = "$\(newValue)"
        }
        
        if(identifier == "portValue")
        {
            self.portfolioWorthLabel.text = "Current Worth: $\(newValue)"
        }
        
        if(identifier == "alert")
        {
            self.tempVar = 0
            self.StockTV.reloadData()
            self.currentStocksAIV.stopAnimating()
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        InvestrCore.observableString.addObserver(self)
        InvestrCore.currWallet.addObserver(self)
        InvestrCore.transactionID.addObserver(self)
        InvestrCore.alertString.addObserver(self)
        self.title = tempName
        self.wallet.text = "$\(InvestrCore.currWallet.value)"
        self.dateLabel.text = "\(self.shortDate)"
        self.refresher = UIRefreshControl()
        self.refresher.addTarget(self, action: "autoRefresh:", forControlEvents: .ValueChanged)
        self.portfolioWorthLabel.text = "Calculating Portfolio Value"
        self.timer = NSTimer.scheduledTimerWithTimeInterval(15.0, target: self, selector: "autoRefresh", userInfo:  nil, repeats: true)
        
      

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setGame(game: Game, userWallet: Double)
    {
        self.tempName = game.name
        self.tempEnd = game.end
        self.shortDate = NSDateFormatter.localizedStringFromDate(self.tempEnd, dateStyle: .ShortStyle, timeStyle: .ShortStyle)
        InvestrCore.currWallet.value = "\(userWallet)"
        self.tempID = game.id
        self.stocksNum = 0
        self.navigationController?.navigationItem.backBarButtonItem?.title = self.tempName
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
        return self.stocks.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! StockTVCell
        
        // Configure the cell...
        cell.nameLabel.text = "\(self.stocks[indexPath.row].name!)"
        cell.numberLabel.text = "\((self.stocks[indexPath.row] as! Stock).value!) Owned Stocks"
        cell.buyLabel.text = "$\((self.stocks[indexPath.row] as! Stock).buyVal!)"
        cell.bidLabel.text = "$\((self.stocks[indexPath.row] as! Stock).bidVal)"
        let tempNum = (self.stocks[indexPath.row] as! Stock).change
        if(tempNum > 0)
        {
            cell.changeLabel.textColor = UIColor.greenColor()
            cell.changeLabel.text = "+\((self.stocks[indexPath.row] as! Stock).change)"
        }
        else if(tempNum < 0)
        {
            cell.changeLabel.textColor = UIColor.redColor()
            cell.changeLabel.text = "\((self.stocks[indexPath.row] as! Stock).change)"
        }
        else
        {
            cell.changeLabel.textColor = UIColor.blackColor()
            cell.changeLabel.text = "\((self.stocks[indexPath.row] as! Stock).change)"
        }
        if(self.tempVar == 2)
        {
            cell.hidden = true
            cell.buyLabel.hidden = true
            cell.bidLabel.hidden = true
            cell.changeLabel.hidden = true
            cell.spinner.startAnimating()
        }
        else if(self.tempVar == 1)
        {
            cell.hidden = false
            cell.buyLabel.hidden = true
            cell.bidLabel.hidden = true
            cell.changeLabel.hidden = true
            cell.spinner.startAnimating()
        }
        else
        {
            cell.hidden = false
            cell.buyLabel.hidden = false
            cell.bidLabel.hidden = false
            cell.changeLabel.hidden = false
            cell.spinner.stopAnimating()
        }
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath!)
    {
        let indexPath = tableView.indexPathForSelectedRow
        let currentCell = tableView.cellForRowAtIndexPath(indexPath!) as! StockTVCell
        let stockVC = self.storyboard?.instantiateViewControllerWithIdentifier("StockVC") as! StockVC
        let tempNum = (self.stocks[indexPath!.row] as! Stock).value
        stockVC.setUp(currentCell.nameLabel.text!, numStocks: tempNum, gameID: self.tempID)
        InvestrCore.getQuote(currentCell.nameLabel.text!, label: self.hiddenLabel, value: "Bid")
        InvestrCore.getQuote(currentCell.nameLabel.text!, label:self.hiddenLabel, value: "Name")
        self.navigationController?.pushViewController(stockVC, animated: true)        
    }
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
