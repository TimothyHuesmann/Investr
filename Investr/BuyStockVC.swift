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

    @IBOutlet weak var lookupButton: UIButton!
    @IBOutlet weak var subTotalLabel: UILabel!
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
    var subTotal : Double!
    
    
    @IBAction func buyButtonPressed(sender: AnyObject)
    {
        InvestrCore.buyStock(Int(self.numBuyingTF.text!)!, ticker: self.tickerLabel.text!)
        InvestrCore.newlyPurchasedStocks = "\(self.tickerLabel.text!)  -   \(self.numBuyingTF.text!)"
        
        InvestrCore.myObservableString.stringValue = "\(self.tickerLabel.text!)  -   \(self.numBuyingTF.text!)"
        
        if(InvestrCore.recentStocks != nil)
        {
            InvestrCore.recentStocks.append("\(self.tickerLabel.text!)  -   \(self.numBuyingTF.text!)")
        }
        else
        {
            InvestrCore.recentStocks = ["\(self.tickerLabel.text!)  -   \(self.numBuyingTF.text!)"]
        }
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    @IBAction func tickerValueChanged(sender: UITextField)
    {
        if(sender.text!.isEmpty)
        {
            self.lookupButton.enabled = false
        }
        else
        {
            self.lookupButton.enabled = true
        }
    }
    
    
    @IBAction func numBuyingValueChanged(sender: UITextField)
    {
        if(sender.text!.isEmpty)
        {
            self.buyButton.enabled = false
        }
        else
        {
            self.buyButton.enabled = true
            self.subTotal = (Double(self.numBuyingTF.text!)!) * (Double(self.askLabel.text!)!)
            self.subTotalLabel.text = "Total: $\(self.subTotal)"
            if(self.subTotal > self.currWallet)
            {
                self.buyButton.enabled = false
            }
            else
            {
                self.buyButton.enabled = true
            }
        }
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func lookupButtonPressed(sender: AnyObject)
    {
        self.tickerTF!.text = self.tickerTF!.text?.uppercaseString
        InvestrCore.checkOwnedStocks(self.numOwnedLabel,tempID: self.tempID, stockName: self.tickerTF!.text!)
        
        //prestage widgets
        InvestrCore.setLabel = self.maxBuyLabel
        InvestrCore.currWallet = self.currWallet
        InvestrCore.numSharesTF = self.numBuyingTF
        
        //make the Ask call which relies on the staged widgets
        InvestrCore.getQuote(self.tickerTF!.text!, label:self.askLabel, value:"Ask")
        
        //do the rest
        InvestrCore.getQuote(self.tickerTF!.text!, label:self.tickerLabel, value:"symbol")
        InvestrCore.getQuote(self.tickerTF!.text!, label:self.nameLabel, value:"Name")
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
    
    func activateLabels()
    {
        self.tickerLabel.hidden = false
        self.nameLabel.hidden = false
        self.askLabel.hidden = false
        self.numOwnedLabel.hidden = false
        self.maxBuyLabel.hidden = false
        self.subTotalLabel.hidden = false
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
