//
//  LoginVC.swift
//  Investr
//
//  Created by Timothy Huesmann on 9/2/15.
//  Copyright (c) 2015 Timothy Huesmann. All rights reserved.
//

import UIKit
import Parse


class LoginVC: UIViewController{
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBAction func submitButtonPressed(sender: AnyObject)
    {
        if(self.userNameTF.text != "" && self.passwordTF.text != "")
        {
            PFUser.logInWithUsernameInBackground(self.userNameTF.text, password: self.passwordTF.text) {
                (user: PFUser?, error: NSError?) -> Void in
                if user != nil {
                    var gamesListTVC = self.storyboard?.instantiateViewControllerWithIdentifier("GamesListTVC") as! GamesListTVC
                    self.navigationController?.pushViewController(gamesListTVC, animated: true)
                    // Do stuff after successful login.
                    InvestrCore.currUser = self.userNameTF.text
                    var query = PFUser.query()
                    query!.whereKey("username", equalTo: InvestrCore.currUser)
                    var user = query!.findObjects()
                    InvestrCore.userID = PFUser.currentUser()!.objectId!
                    
                } else {
                    var alert = UIAlertView()
                    alert.title = "Login Error"
                    alert.message = "Invalid Email/Password Combination, Please Try Again"
                    alert.addButtonWithTitle("OK")
                    alert.show()
                    // The login failed. Check error to see why.
                }
            }
        }
        else
        {
            var alert = UIAlertView()
            alert.title = "Login Error"
            alert.message = "Invalid Email/Password Combination, Please Try Again"
            alert.addButtonWithTitle("OK")
            alert.show()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func VCDidFinish(controller: GamesListTVC)
    {
        controller.navigationController?.popViewControllerAnimated(true)
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    var currentUser = PFUser.currentUser()
    var upcomingGamesnum = 0
    var upcomingGames = [AnyObject]()
    var playingGamesnum = 0
    var playingGames = [AnyObject]()
    
    if(segue.identifier == "gamesListSegue")
    {
    let vc = segue.destinationViewController as! GamesListTVC
    vc.upcomingGamesnum = upcomingGamesnum
    vc.upcomingGames = upcomingGames
    vc.playingGamesnum = playingGamesnum
    vc.playingGames = playingGames
    vc.delegate = self
    }
    }
    */
    
    
}

