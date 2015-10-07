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
    var ticker: String!
    var gameID: String!
    
    @IBAction func sellButtonPressed(sender: AnyObject)
    {
        InvestrCore.selling = true
        InvestrCore.sellStock((Int(self.numSellingTF.text!)!), ticker: self.ticker)
        InvestrCore.observableString.updateValue ("\(self.ticker)-\(self.numSellingTF.text!)")
        self.navigationController?.popViewControllerAnimated(true)
        
        
        
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
        self.numStocksOwned = numStocks
        self.ticker = ticker
        self.gameID = gameID
        //self.currPrice = ask
        //self.name = name
    }
    
    override func viewWillAppear(animated: Bool)
    {
        
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.currPrice = (Double(InvestrCore.tempAsk)!)
        self.totalWorth = (self.currPrice) * (Double(self.numStocksOwned))
        self.currPriceLabel.text = "\(self.currPrice)"
        
        self.totalWorthLabel.text = "\(self.totalWorth)"

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
