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
    @IBOutlet weak var numPlayers: UILabel!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var enterGameButton: UIButton!
    @IBAction func enterButtonPressed(sender: AnyObject)
    {
        var alert = UIAlertController(title: "Confirm?", message: "Are you sure you want to enter this game?", preferredStyle: UIAlertControllerStyle.Alert)
        let okButton = UIAlertAction(title:"Yes", style: .Default, handler:
            {
                (action: UIAlertAction!) in
                println("Hello")
            })
        alert.addAction(okButton)
        
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