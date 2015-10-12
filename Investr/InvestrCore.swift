//
//  InvestrCore.swift
//  Investr
//
//  Created by Timothy Huesmann on 9/2/15.
//  Copyright (c) 2015 Timothy Huesmann. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Parse

class InvestrCore: NSObject
{
    static var currUser = ""        //current user Username
    static var userID = ""          //current user objectID
    static var tempValue: String!
    static var setLabel: UILabel!
    static var currWallet = ObservableString(value: "", identifier: "wallet")
    static var numSharesTF: UITextField!
    static var transactionID: String!
    static var observableString = ObservableString(value:"", identifier:"buyStock")
    static var tempID : String!
    static var selling = false
    static var tempAsk = ObservableString(value:"", identifier:"tempAsk")
    static var tempName = ObservableString(value:"", identifier:"tempName")
    
    static func buyStock(numStocks: Int, ticker: String)
    {
        print("numStocks: \(numStocks) ticker: \(ticker)")
        Alamofire.request(.POST, "https://investr-app.herokuapp.com/mobile/buy", parameters: ["transaction_id": self.transactionID, "buy_number": numStocks, "stock_symbol":ticker], encoding: .JSON)
            .responseString { (request, response, data) in
                //print(request)
                //print(response)
                //print(data)
        }
    }
    
    static func sellStock(amount: Int, ticker: String)
    {
        Alamofire.request(.POST, "https://investr-app.herokuapp.com/mobile/sell", parameters: ["transaction_id": self.transactionID, "sell_number": amount, "stock_symbol": ticker],
            encoding: .JSON)
            .responseString { (request, response, data) in
        
        }
    }
    
    static func joinGame(userID: String, gameID: String)
    {
        Alamofire.request(.POST, "https://investr-app.herokuapp.com/mobile/joinGame", parameters: ["user_id": userID, "game_id": gameID], encoding: .JSON)
            .responseString { (request, response, data) in
                print(request)
                print(response)
                print(data)
        }
    }
    
    static func getQuote(ticker: String, label: UILabel, value: String)
    {
            Alamofire.request(.GET, "https://investr-app.herokuapp.com/mobile/quote/\(ticker)")
                .responseJSON { response in
    
                    label.text = ((response.2.value![value]!) as! String)
                    
                    if(value == "Ask")
                    {
                        self.tempAsk.value = ((response.2.value![value]!) as! String)
                        let num = Int((Double(InvestrCore.currWallet.value)!) / Double(self.tempAsk.value)!)
                        
                        if((InvestrCore.setLabel) != nil)
                        {
                            InvestrCore.setLabel.text = "\(num)"
                            self.numSharesTF.becomeFirstResponder()
                        
                        //unstage prestaged widgets
                            InvestrCore.setLabel = nil
                            InvestrCore.numSharesTF = nil
                        }
                        
                    }
                    else if(value == "Name")
                    {
                        self.tempName.value = ((response.2.value![value]!) as! String)
                    }
            }
    }
    
    static func checkOwnedStocks(numOwnedLabel: UILabel, tempID: String, stockName: String)
    {
            let query = PFQuery(className: "Transaction")
            query.whereKey("GameID", equalTo: PFObject(withoutDataWithClassName: "Game", objectId: tempID))
            query.whereKey("userName", equalTo: InvestrCore.currUser)
            do
            {
                let theObjects =  try query.findObjects()
                if theObjects[0]["stocksInHand"] != nil
                {
                    
                    for(var i = 0; i < theObjects[0]["stocksInHand"].count!;i++)
                    {
                        let tempStock = theObjects[0]["stocksInHand"][i] as! NSDictionary
                        let tempStockName = tempStock["symbol"] as! NSString
                        if tempStockName == stockName
                        {
                            let tempName = tempStock["share"] as! NSString
                            numOwnedLabel.text = "Stocks Owned: \(tempName)"
                            i = 1000000000
                        }
                        else
                        {
                            numOwnedLabel.text = "Stocks Owned: 0"
                        }
                        
                    }
                }
                else
                {
                    numOwnedLabel.text = "Stocks Owned: 0"
                }
            }
            catch
            {
                
            }
            
    }
    
    static func indexOfStock(array: [Stock], name: String) -> Int
    {
        for(var i = 0; i<array.count;i++)
        {
            if(array[i].name == name)
            {
                return i
            }
            else
            {
                
            }
        }
        
        return -1
    }
    
}
