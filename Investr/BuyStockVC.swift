//
//  BuyStockVC.swift
//  Investr
//
//  Created by Michael Litman on 9/28/15.
//  Copyright © 2015 Timothy Huesmann. All rights reserved.
//

import UIKit

class BuyStockVC: UIViewController {

    @IBOutlet weak var theLabel: UILabel!
    @IBOutlet weak var tickerTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func lookupButtonPressed(sender: AnyObject)
    {
        InvestrCore.getQuote(self.tickerTF!.text!, label:self.theLabel)
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
