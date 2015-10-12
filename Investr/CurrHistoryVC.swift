//
//  CurrHistoryVC.swift
//  Investr
//
//  Created by Timothy Huesmann on 10/12/15.
//  Copyright © 2015 Timothy Huesmann. All rights reserved.
//

import UIKit
import Parse

class CurrHistoryVC: UIViewController
{
    var gameID: String!

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
    
    func getHistory()
    {
        let query = PFQuery(className: "Transaction")
        query.whereKey("userName", equalTo: InvestrCore.currUser)
        query.whereKey("GameID", equalTo: self.gameID)
        query.findObjectsInBackgroundWithBlock
        {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            
        }
        
    }
    
    func setUp(gameID: String)
    {
        self.gameID = gameID
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
