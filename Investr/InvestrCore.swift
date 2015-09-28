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
    
    static func joinGame(userID: String, gameID: String)
    {
        Alamofire.request(.POST, "https://investr-app.herokuapp.com/joinGame", parameters: ["user_id": userID, "game_id": gameID], encoding: .JSON)
            .responseString { (request, response, data) in
                print(request)
                print(response)
                print(data)
        }
    }
    
    static func getQuote(ticker: String, label: UILabel)
    {
        Alamofire.request(.GET, "https://investr-app.herokuapp.com/quote/\(ticker)")
            .responseJSON { response in
                
                label.text = (response.2.value!["Ask"]!) as! String
        }
    }

}
