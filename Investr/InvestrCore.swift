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
    static var currWallet: Double!
    static var numSharesTF: UITextField!
    static var transactionID: String!
    static var recentStocks: [String]!
    static var newlyPurchasedStocks: String = ""{willSet(newValue){
        print("newlyPurchasedStocks will change from "+newlyPurchasedStocks+" to "+newValue)
        }
        didSet{
            print("newlyPurchasedStocks did change from "+oldValue+" to "+newlyPurchasedStocks)
        }
    }
    
    static var genericStringObserver : ObservableString.Observer = (willSetObserver,didSetObserver)
    
    static var myObservableString = ObservableString(initialValue:"initalValue")
    
    
    
    static var willSetObserver : ObservableString.WillSet = {
        (currentValue:String?, tobeValue:String?) ->() in
       print("New value will be: \(tobeValue)")    }
    
    
    static var didSetObserver : ObservableString.DidSet = {
        (oldValue:String?,currentValue:String?) -> () in
        print("New value is: \(currentValue)")    }
    
    static func buyStock(numStocks: Int, ticker: String)
    {
        print("numStocks: \(numStocks) ticker: \(ticker)")
        Alamofire.request(.POST, "https://investr-app.herokuapp.com/mobile/buy", parameters: ["transaction_id": self.transactionID, "buy_number": numStocks, "stock_symbol":ticker], encoding: .JSON)
            .responseString { (request, response, data) in
                print(request)
                print(response)
                print(data)
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
                        let num = Int(InvestrCore.currWallet / Double(label.text!)!)
                        InvestrCore.setLabel.text = "\(num)"
                        self.numSharesTF.hidden = false
                        self.numSharesTF.becomeFirstResponder()
                        
                        //unstage prestaged widgets
                        InvestrCore.setLabel = nil
                        InvestrCore.currWallet = nil
                        InvestrCore.numSharesTF = nil
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
                        var tempStock = theObjects[0]["stocksInHand"][i] as! NSDictionary
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
            
            
            numOwnedLabel.hidden = false
            
    }
    
}
