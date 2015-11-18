//
//  LookupStockVC.swift
//  Investr
//
//  Created by Timothy Huesmann on 11/11/15.
//  Copyright © 2015 Timothy Huesmann. All rights reserved.
//

import UIKit

class LookupStockVC: UIViewController, UIWebViewDelegate
{

    @IBOutlet weak var tickerTF: UITextField!
    @IBOutlet weak var lookupButton: UIButton!
    @IBOutlet weak var stockWV: UIWebView!
    @IBOutlet weak var buyStockButton: UIButton!
    
    
    @IBAction func buyStockButtonPressed(sender: AnyObject)
    {
        let buyStockVC = self.storyboard?.instantiateViewControllerWithIdentifier("BuyStockVC") as! BuyStockVC
        self.navigationController?.pushViewController(buyStockVC, animated: true)
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let url = NSURL(string: "http://finance.yahoo.com")
        let requestObject = NSURLRequest(URL: url!)
        self.stockWV.loadRequest(requestObject)
        self.stockWV.hidden = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?)
    {
        print("Webview fail with error \(error)");
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool
    {
        return true;
    }
    
    func webViewDidStartLoad(webView: UIWebView)
    {
        print("Webview started Loading")
    }
    
    func webViewDidFinishLoad(webView: UIWebView)
    {
        print("Webview did finish load")
        self.buyStockButton.enabled = true
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