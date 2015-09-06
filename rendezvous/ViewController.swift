//
//  ViewController.swift
//  rendezvous
//
//  Created by Philippe Kimura-Thollander on 9/4/15.
//  Copyright © 2015 Philippe Kimura-Thollander. All rights reserved. Wat
//  Varun was here too xD
//


import UIKit
import AudioToolbox
import AVFoundation
import CoreBluetooth

class ViewController: UIViewController{
    
    @IBOutlet weak var rSubtitle: UILabel!
    @IBOutlet weak var rTitle: UILabel!

    @IBOutlet weak var facebook: UIButton!
    @IBOutlet weak var contacts: UIButton!
    
    var uname: NSString = ""
    var id: NSString = ""
    var result: NSString = ""
    var friends: NSArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        rTitle.textAlignment = .Center
        rSubtitle.textAlignment = .Center
        
        facebook.layer.cornerRadius = 5
        facebook.layer.borderWidth = 1
        facebook.layer.borderColor = UIColor.whiteColor().CGColor
        
        facebook.addTarget(self, action: "facebookLogin", forControlEvents: UIControlEvents.TouchUpInside)
        
        contacts.layer.cornerRadius = 5
        contacts.layer.borderWidth = 1
        contacts.layer.borderColor = UIColor.whiteColor().CGColor
        
    }
    
    override func viewDidAppear(animated: Bool) {
        self.view.hidden = true
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            // User is already logged in, do work such as go to next view controller.
            getUserData()
            performSegueWithIdentifier("LoggedIn", sender: self)
        }

    }
    
    @IBAction func facebookLogin() {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager .logInWithReadPermissions(["email"], handler: { (result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
            }
            
            if (error == nil){
                let fbLoginResult : FBSDKLoginManagerLoginResult! = result
                if(fbLoginResult != nil)
                {
                    if(fbLoginResult.grantedPermissions.contains("email")){
                        self.getUserData()
                        self.performSegueWithIdentifier("LoggedIn", sender: self)
                        
                    }
                }
            }
        })
    }
    
    func getUserData()
    {
        
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                print("fetched user: \(result)")
                let userName : NSString = result.valueForKey("name") as! NSString
                print("User Name is: \(userName)")
                let userId : NSString = result.valueForKey("id") as! NSString
                print ("User ID is: \(userId)")
                self.uname = userName
                self.id = userId
                self.result = "\(result)"
            }
        })
        
        let fbRequest = FBSDKGraphRequest(graphPath:"/me/friends", parameters: nil);
        fbRequest.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
            
            if error == nil {
                
                print("Friends are : \(result)")
                
            } else {
                
                print("Error Getting Friends \(error)");
                
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "LoggedIn") {
            //get a reference to the destination view controller
            let destinationVC:allSet = segue.destinationViewController as! allSet
            
            //set properties on the destination view controller
            destinationVC.uname = self.uname
            destinationVC.id = self.id
            destinationVC.result = self.result
            destinationVC.friends = self.friends
            //etc...
        }
    }
    
}