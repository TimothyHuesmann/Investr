//
//  StockVC.swift
//  Investr
//
//  Created by Timothy Huesmann on 9/30/15.
//  Copyright © 2015 Timothy Huesmann. All rights reserved.
//

import UIKit

class StockVC: UIViewController
{

    @IBOutlet weak var numSellingTF: UITextField!
    @IBOutlet weak var payoutLabel: UILabel!
    @IBOutlet weak var totalWorthLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numStocksOwnedLabel: UILabel!
    @IBOutlet weak var currPriceLabel: UILabel!
    
    @IBOutlet weak var sellButton: UIButton!
    @IBOutlet weak var sellAllButton: UIButton!
    
    var currPrice : Double!
    var numStocksOwned : Int!
    var totalWorth : Double!
    var name : String!
    var payout : Double!
    
    @IBAction func sellButtonPressed(sender: AnyObject)
    {
        
    }
    
    @IBAction func sellAllButtonPressed(sender: AnyObject)
    {
        
    }
    
    @IBAction func sellValueChanged(sender: UITextField)
    {
        if(sender.text == nil)
        {
            self.sellButton.enabled = false
        }
        else
        {
            self.payout = self.currPrice * (Double(self.numSellingTF.text!)!)
            self.sellButton.enabled = true
            self.payoutLabel.text = "Payout: $\(self.payout)"
        }
    }
    
    func setUp(ticker: String, numStocks: Int, gameID: String)
    {
        InvestrCore.checkOwnedStocks(self.numStocksOwnedLabel, tempID: gameID, stockName: ticker)
        InvestrCore.getQuote(ticker, label: self.currPriceLabel, value: "Ask")
        InvestrCore.getQuote(ticker, label: self.nameLabel, value: "Name")
        self.currPrice = (Double(self.currPriceLabel.text!)!)
        self.totalWorth = (self.currPrice) * (Double(self.numStocksOwnedLabel.text!)!)
    }
    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
