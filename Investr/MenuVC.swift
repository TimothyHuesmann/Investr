//
//  MenuVC.swift
//  Investr
//
//  Created by Timothy Huesmann on 9/14/15.
//  Copyright (c) 2015 Timothy Huesmann. All rights reserved.
//

import UIKit
import Parse

class MenuVC: UIViewController {

    
    var currentUser = PFUser.currentUser()
    
    @IBAction func upcomingGamesButtonPressed(sender: AnyObject)
    {
        let gameslistVC = self.storyboard?.instantiateViewControllerWithIdentifier("GamesListTVC") as! GamesListTVC
        self.navigationController?.pushViewController(gameslistVC, animated: true)
    }
    
    @IBAction func myGamesButtonPressed(sender: AnyObject)
    {
        let myGamesVC = self.storyboard?.instantiateViewControllerWithIdentifier("MyGamesTVC") as! MyGamesTVC
        self.navigationController?.pushViewController(myGamesVC, animated: true)
    }
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
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
