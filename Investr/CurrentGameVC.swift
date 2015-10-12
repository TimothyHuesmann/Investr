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

    
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var hiddenLabel: UILabel!
    @IBOutlet weak var StockTV: UITableView!
    @IBOutlet weak var wallet: UILabel!
    var tempName : String!
    var stocksNum : Int!
    var stocks = [Stock]()
    var tempEnd = NSDate()
    var tempID : String!
    var tempStock : NSDictionary!
    var stockNames = [String]()
    
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBAction func historyButtonPressed(sender: AnyObject)
    {
        let currHistoryVC = self.storyboard?.instantiateViewControllerWithIdentifier("CurrHistoryVC") as! CurrHistoryVC
        currHistoryVC.setUp(self.tempID)
        self.navigationController?.pushViewController(currHistoryVC, animated: true)
    }
    
    @IBAction func buyButtonPressed(sender: AnyObject)
    {
        let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("BuyStockVC") as! BuyStockVC
        viewController.getInfo((Double(InvestrCore.currWallet.value))!, tempID: self.tempID)
        self.navigationController?.pushViewController(viewController, animated: true)
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
                    InvestrCore.transactionID = objects[0].objectId
                    if objects[0]["stocksInHand"] != nil
                    {
                        self.stocksNum = objects[0]["stocksInHand"].count
                        for(var i = 0; i < self.stocksNum;i++)
                        {
                            self.tempStock = objects[0]["stocksInHand"][i] as! NSDictionary
                            let tempNumStock =  self.tempStock["share"] as! NSString
                            let tempStockName = self.tempStock["symbol"] as! NSString
                            let newStock = Stock(name: tempStockName as String, value: (Int(tempNumStock as String))!)
                            self.stocks.append(newStock)
                            self.stockNames.append("\(tempStockName)")
                            
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
    
    func observableStringUpdate(newValue: String, identifier: String)
    {
        print("I received \(newValue) for variable: \(identifier)")
        if(identifier == "buyStock")
        {
            let tempVal = newValue.componentsSeparatedByString("-")
            let tempStock = Stock(name: tempVal[0], value: (Int(tempVal[1]))!)
            if InvestrCore.selling == false
            {
                if(InvestrCore.indexOfStock(self.stocks, name: tempStock.name) != -1)
                {
                    let tempIndex = InvestrCore.indexOfStock(self.stocks, name: tempStock.name)
                    self.stocks[tempIndex].value = self.stocks[tempIndex].value + tempStock.value
                }
                else
                {
                    self.stocks.append(tempStock)
                }
                
            }
            else
            {
                let tempIndex = InvestrCore.indexOfStock(self.stocks, name: tempStock.name)
                self.stocks[tempIndex].value = self.stocks[tempIndex].value - tempStock.value
                if(self.stocks[tempIndex].value == 0)
                {
                    self.stocks.removeAtIndex(tempIndex)
                }
            }
        }
        
        if(identifier == "wallet")
        {
           self.wallet.text = "$\(newValue)"
        }
        self.StockTV.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        InvestrCore.observableString.addObserver(self)
        InvestrCore.currWallet.addObserver(self)
        self.title = tempName
        self.wallet.text = "$\(InvestrCore.currWallet.value)"
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
        InvestrCore.currWallet.value = "\(userWallet)"
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
        return self.stocks.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! StockTVCell
        
        // Configure the cell...
        cell.nameLabel.text = self.stocks[indexPath.row].name
        cell.numberLabel.text = "\(self.stocks[indexPath.row].value)"
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath!)
    {
        let indexPath = tableView.indexPathForSelectedRow
        let currentCell = tableView.cellForRowAtIndexPath(indexPath!) as! StockTVCell
        let stockVC = self.storyboard?.instantiateViewControllerWithIdentifier("StockVC") as! StockVC
        stockVC.setUp(currentCell.nameLabel.text!, numStocks: (Int(currentCell.numberLabel.text!)!), gameID: self.tempID)
        InvestrCore.getQuote(currentCell.nameLabel.text!, label: self.hiddenLabel, value: "Ask")
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
