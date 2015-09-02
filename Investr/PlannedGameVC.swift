//
//  PlannedGameVC.swift
//  Investr
//
//  Created by Timothy Huesmann on 9/2/15.
//  Copyright (c) 2015 Timothy Huesmann. All rights reserved.
//

import UIKit

class PlannedGameVC: UIViewController {
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var enterGameButton: UIButton!
    @IBAction func enterButtonPressed(sender: AnyObject)
    {
        var alert = UIAlertView()
        alert.title = "Confirm?"
        alert.message = "Are You Sure You Want to Enter This Game?"
        alert.addButtonWithTitle("Why Wouldn't I?")
        alert.show()
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