//
//  BuyStockVC.swift
//  Investr
//
//  Created by Michael Litman on 9/28/15.
//  Copyright © 2015 Timothy Huesmann. All rights reserved.
//

import UIKit
import Parse

class BuyStockVC: UIViewController, Observable {

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
    @IBOutlet weak var spinnerAIV: UIActivityIndicatorView!
    var currWallet : Double!
    var tempID: String!
    var tempStock: NSDictionary!
    var tempMaxNum: Int!
    var tempMax : Double!
    var subTotal : Double!
    var price : String!
    
    
    @IBAction func buyButtonPressed(sender: AnyObject)
    {
        InvestrCore.selling = false
        InvestrCore.buyStock(Int(self.numBuyingTF.text!)!, ticker: self.tickerLabel.text!)
        InvestrCore.observableString.updateValue ("\(self.tickerLabel.text!)-\(self.numBuyingTF.text!)")
        self.navigationController?.popViewControllerAnimated(true)
        self.currWallet = self.currWallet - self.subTotal
        InvestrCore.currWallet.value = (NSString(format:"%.2f", self.currWallet)) as String
        
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
            self.subTotal = (Double(self.numBuyingTF.text!)!) * (Double(self.price)!)
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
        InvestrCore.tempName.addObserver(self)
        InvestrCore.tempAsk.addObserver(self)
        InvestrCore.alertString.addObserver(self)

        // Do any additional setup after loading the view.
    }

    @IBAction func lookupButtonPressed(sender: AnyObject)
    {
        self.hideLabels()
        self.tickerTF!.text = self.tickerTF!.text?.uppercaseString
        self.spinnerAIV.hidden = false
        self.spinnerAIV.startAnimating()
        InvestrCore.checkOwnedStocks(self.numOwnedLabel,tempID: self.tempID, stockName: self.tickerTF!.text!)
        
        //prestage widgets
        InvestrCore.setLabel = self.maxBuyLabel
        InvestrCore.numSharesTF = self.numBuyingTF
        
        //make the Ask call which relies on the staged widgets
        InvestrCore.getQuote(self.tickerTF!.text!, label:self.askLabel, value:"Ask")
        
        //do the rest
        InvestrCore.getQuote(self.tickerTF!.text!, label:self.tickerLabel, value:"symbol")
        InvestrCore.getQuote(self.tickerTF!.text!, label:self.nameLabel, value:"Name")
        
        
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
        self.spinnerAIV.stopAnimating()
        self.tickerLabel.hidden = false
        self.nameLabel.hidden = false
        self.askLabel.hidden = false
        self.numOwnedLabel.hidden = false
        self.maxBuyLabel.hidden = false
        self.subTotalLabel.hidden = false
        self.numBuyingTF.hidden = false
        self.numBuyingTF.enabled = true
    }
    
    func hideLabels()
    {
        self.spinnerAIV.startAnimating()
        self.tickerLabel.hidden = true
        self.nameLabel.hidden = true
        self.askLabel.hidden = true
        self.numOwnedLabel.hidden = true
        self.maxBuyLabel.hidden = true
        self.subTotalLabel.hidden = true
        self.numBuyingTF.hidden = true
        self.numBuyingTF.enabled = false
    }
    
    func observableStringUpdate(newValue: String, identifier: String)
    {
        
        
        if(identifier == "tempAsk")
        {
            self.price = newValue
        }
        if(identifier == "tempName")
        {
            self.maxBuyLabel.text = "Maximum Stocks Affordable: \(self.maxBuyLabel.text!)"
            self.askLabel.text = "Stock Price: $\(self.askLabel.text!)"
            activateLabels()
        }
        if(identifier == "alert")
        {
            if(newValue == "No Ask")
            {
                self.spinnerAIV.stopAnimating()
                let alertController = UIAlertController(title: "Market Error", message: "This stock is not currently for sale.", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
        
        
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
