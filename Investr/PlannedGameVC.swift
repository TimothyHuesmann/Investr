//
//  PlannedGameVC.swift
//  Investr
//
//  Created by Timothy Huesmann on 9/2/15.
//  Copyright (c) 2015 Timothy Huesmann. All rights reserved.
//

import UIKit

class PlannedGameVC: UIViewController {
    
    @IBOutlet weak var potSizeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var numPlayers: UILabel!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var enterGameButton: UIButton!
    @IBOutlet weak var gameName: UILabel!
    var tempGameName : String!
    var tempNumPlayers : Int!
    var tempPriceLabel : Double!
    var tempPotSize : Int!
    var gameID : String!
    @IBAction func enterButtonPressed(sender: AnyObject)
    {
        let alertController = UIAlertController(title: "Confirm", message:
            "Are your sure to join the game?", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default,handler: nil))
        alertController.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
        //needs to add a confirmation button
        //needs to add the function to add to the game
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.gameName.text = self.tempGameName
        self.numPlayers.text = "\(self.tempNumPlayers)"
        self.priceLabel.text = "\(self.tempPriceLabel)"
        self.potSizeLabel.text = "\(self.tempPotSize)"
        
        

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setGameInfo(name: String, numPlayers: Int, potSize: Int, price: Double, gameID: String)
    {
        self.tempGameName = name
        self.tempNumPlayers = numPlayers
        self.tempPriceLabel = price
        self.tempPotSize = potSize
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