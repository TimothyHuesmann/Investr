//
//  LookupStockVC.swift
//  Investr
//
//  Created by Timothy Huesmann on 11/11/15.
//  Copyright © 2015 Timothy Huesmann. All rights reserved.
//

import UIKit

class LookupStockVC: UIViewController
{

    @IBOutlet weak var tickerTF: UITextField!
    @IBOutlet weak var lookupButton: UIButton!
    @IBOutlet weak var stockWV: UIWebView!
    @IBOutlet weak var buyStockButton: UIButton!
    
    
    @IBAction func buyStockButtonPressed(sender: AnyObject)
    {
        
    }
    
    @IBAction func lookupButtonPressed(sender: AnyObject)
    {
        let url = NSURL(string: "http://finance.yahoo.com/echarts?s=\(self.tickerTF.text)+Interactive#{\"range\":\"1d\",\"allowChartStacking\":true}")
        let requestObject = NSURLRequest(URL: url!)
        self.stockWV.loadRequest(requestObject)
        self.stockWV.hidden = false
        self.buyStockButton.enabled = true
    }
    
    @IBAction func tickerValueChanged(sender: UITextField)
    {
        if(sender.text!.isEmpty)
        {
            self.lookupButton.enabled = false
        }
        else
        {
            self.lookupButton.enabled = true
        }
    }
    
    
    
    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
