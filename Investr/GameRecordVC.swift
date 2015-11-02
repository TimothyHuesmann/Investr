//
//  GameRecordVC.swift
//  Investr
//
//  Created by Timothy Huesmann on 10/14/15.
//  Copyright © 2015 Timothy Huesmann. All rights reserved.
//

import UIKit

class GameRecordVC: UIViewController, Observable
{

    @IBOutlet weak var finalMoneyLabel: UILabel!
    @IBOutlet weak var potSizeLabel: UILabel!
    @IBOutlet weak var userPlaceLabel: UILabel!
    @IBOutlet weak var numPlayersLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var finalStandingsButton: UIButton!
    @IBOutlet weak var gameTransactionsButton: UIButton!
    var tempMoney: Double!
    var tempPot: Double!
    var tempPlace: Int!
    var tempPlayers: Int!
    var tempEnd: NSDate!
    var record: GameRecord!
    
    @IBAction func transactionsButtonPressed(sender: AnyObject)
    {
        let currHistoryVC = self.storyboard?.instantiateViewControllerWithIdentifier("CurrHistoryVC") as! CurrHistoryVC
        currHistoryVC.theTransactions = self.record.theTransactions
        self.navigationController?.pushViewController(currHistoryVC, animated: true)
        
    }
    
    @IBAction func finalStandingsButtonPressed(sender: AnyObject)
    {
        
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        InvestrCore.finalMoney.addObserver(self)
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getInfo(record: GameRecord)
    {
        self.tempPot = record.pot
        self.tempPlace = record.place
        self.tempPlayers = record.numPlayers
        self.tempEnd = record.end
        self.record = record
    }
    
    func observableStringUpdate(newValue: String, identifier: String)
    {
        self.potSizeLabel.text = "Pot Size: $\(self.tempPot)"
        self.userPlaceLabel.text = "Place: \(self.tempPlace)"
        self.numPlayersLabel.text = "Number of Players: \(self.tempPlayers)"
        self.endTimeLabel.text = "End Time: \(self.tempEnd)"
        self.finalMoneyLabel.text = "Ending Money: $\(newValue)"
        activateLabels()
    }
    
    func activateLabels()
    {
        self.potSizeLabel.hidden = false
        self.userPlaceLabel.hidden = false
        self.numPlayersLabel.hidden = false
        self.endTimeLabel.hidden = false
        self.finalMoneyLabel.hidden = false
        self.gameTransactionsButton.hidden = false
        self.finalStandingsButton.hidden = false
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
