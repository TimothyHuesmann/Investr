//
//  BuyStockVC.swift
//  Investr
//
//  Created by Michael Litman on 9/28/15.
//  Copyright © 2015 Timothy Huesmann. All rights reserved.
//

import UIKit
import Parse

class BuyStockVC: UIViewController {

    @IBOutlet weak var numBuyingTF: UITextField!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var maxBuyLabel: UILabel!
    @IBOutlet weak var numOwnedLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tickerLabel: UILabel!
    @IBOutlet weak var askLabel: UILabel!
    @IBOutlet weak var tickerTF: UITextField!
    var currWallet : Double!
    var tempID: String!
    var tempStock: NSDictionary!
    var tempMaxNum: Int!
    var tempMax : Double!
    
    
    
    @IBAction func buyButtonPressed(sender: AnyObject)
    {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func lookupButtonPressed(sender: AnyObject)
    {
        checkStocks(self.tickerTF!.text!)
        self.askLabel.text = InvestrCore.getQuote(self.tickerTF!.text!, info:"Ask") as String
        self.tickerLabel.text = InvestrCore.getQuote(self.tickerTF!.text!, info:"symbol") as String
        self.nameLabel.text = InvestrCore.getQuote(self.tickerTF!.text!, info:"Name") as String
        self.tempMax = self.currWallet/(InvestrCore.getQuote(self.tickerTF.text!, info: "Ask") as NSString).doubleValue
        self.maxBuyLabel.text = "Max Possible Buy: \(self.tempMax)"
        activateLabels()
        
    }
    
    func getInfo(wallet: Double, tempID: String)
    {
        self.currWallet = wallet
        self.tempID = tempID
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func checkStocks(ticker: String)
    {
        let query = PFQuery(className: "Transaction")
        query.whereKey("GameID", equalTo: PFObject(withoutDataWithClassName: "Game", objectId: self.tempID))
        query.whereKey("userName", equalTo: InvestrCore.currUser)
        do
        {
            let theObjects =  try query.findObjects()
            if theObjects[0]["stocksInHand"] != nil
            {
                
                for(var i = 0; i < theObjects[0]["stocksInHand"].count!;i++)
                {
                    self.tempStock = theObjects[0]["stocksInHand"][i] as! NSDictionary
                    let tempStockName = self.tempStock["symbol"] as! NSString
                    if tempStockName == self.tickerTF.text!
                    {
                        let tempName = self.tempStock["share"] as! NSString
                        self.numOwnedLabel.text = "Stocks Owned: \(tempName)"
                        i = 1000000000
                    }
                    else
                    {
                        self.numOwnedLabel.text = "Stocks Owned: 0"
                    }
                    
                }
            }
            else
            {
                self.numOwnedLabel.text = "Stocks Owned: 0"
            }
        }
        catch
        {
            
        }
        
        
        self.numOwnedLabel.hidden = false
        
    }
    
    func activateLabels()
    {
        self.tickerLabel.hidden = false
        self.nameLabel.hidden = false
        self.askLabel.hidden = false
        self.numOwnedLabel.hidden = false
        self.maxBuyLabel.hidden = false
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
