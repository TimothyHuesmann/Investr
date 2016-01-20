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

    @IBOutlet weak var gamesTV: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var theGames = [Game]()
    var thePortfolios = [String]()
    
    
    var currentUser = PFUser.currentUser()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if self.revealViewController() != nil
        {
            self.menuButton.target = self.revealViewController()
            self.menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        return 1
        
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! MenuGameListTVCell
        
        // Configure the cell...
        
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath!)
    {
       /*
        let indexPath = tableView.indexPathForSelectedRow
        let currentCell = tableView.cellForRowAtIndexPath(indexPath!) as UITableViewCell!
        
        let query = PFQuery(className: "Transaction")
        query.whereKey("userName", equalTo: InvestrCore.currUser)
        query.findObjectsInBackgroundWithBlock
            {
                (objects: [PFObject]?, error: NSError?) -> Void in
                if error == nil
                {
                    if let objects = objects
                    {
                        let tempWallet = objects[0]["currentMoney"] as! Double
                        let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("CurrentGameVC") as! CurrentGameVC
            
                            viewController.setGame(self.theGames[(indexPath?.row)!], userWallet: tempWallet)
                        
                        
                        viewController.getStocks()
                        self.navigationController?.pushViewController(viewController, animated: true)
                        self.theGames = []
                    }
                }
                else
                {
                    print("Error: \(error) \(error!.userInfo)")
                }
        }

        */
        
        
        //NEED GAME GETTER BEFORE THIS CAN BE ACTIVATED
        
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
