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
    
    static func buyStock(numStocks: Int, ticker: String)
    {
        Alamofire.request(.POST, "https://investr-app.herokuapp.com/buy", parameters: ["transaction_id": self.transactionID, "buy_number": numStocks, "stock_symbol":ticker], encoding: .JSON)
            .responseString { (request, response, data) in
                print(request)
                print(response)
                print(data)
        }
    }
    
    static func joinGame(userID: String, gameID: String)
    {
        Alamofire.request(.POST, "https://investr-app.herokuapp.com/joinGame", parameters: ["user_id": userID, "game_id": gameID], encoding: .JSON)
            .responseString { (request, response, data) in
                print(request)
                print(response)
                print(data)
        }
    }
    
    static func getQuote(ticker: String, label: UILabel, value: String)
    {
            Alamofire.request(.GET, "https://investr-app.herokuapp.com/quote/\(ticker)")
                .responseJSON { response in
    
                    label.text = (response.2.value![value]!) as! String
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
}
