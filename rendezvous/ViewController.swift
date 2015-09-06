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
import MapKit
import CoreLocation
import CoreBluetooth

class ViewController: UIViewController, CLLocationManagerDelegate, CBPeripheralManagerDelegate{
    
    @IBOutlet weak var rSubtitle: UILabel!
    @IBOutlet weak var rTitle: UILabel!

    @IBOutlet weak var facebook: UIButton!
    @IBOutlet weak var contacts: UIButton!
    
    @IBOutlet weak var logoImage: UIImageView!
    let locationManager = CLLocationManager()
    let appuid: String! = "29B1AD96-1DF0-4392-8C8A-7387F9E7BD84"
    var region = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "29B1AD96-1DF0-4392-8C8A-7387F9E7BD84")!, identifier: "")
    var periphmanager: CBPeripheralManager! = nil
    
    var uname: NSString = ""
    var id: NSString = ""
    var result: NSString = ""
    var friends: NSArray = []
    
    override func viewWillAppear(animated: Bool) {
        
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            // User is already logged in, do work such as go to next view controller.
            performSegueWithIdentifier("LoggedIn", sender: nil)
            getUserData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            // User is already logged in, do work such as go to next view controller.
            getUserData()
            beginBroadcasting()
        }
        
        print(appuid);
        
        rTitle.textAlignment = .Center
        rSubtitle.textAlignment = .Center
        
        facebook.layer.cornerRadius = 5
        facebook.layer.borderWidth = 1
        facebook.layer.borderColor = UIColor.whiteColor().CGColor
        
        facebook.addTarget(self, action: "facebookLogin", forControlEvents: UIControlEvents.TouchUpInside)
        
        contacts.layer.cornerRadius = 5
        contacts.layer.borderWidth = 1
        contacts.layer.borderColor = UIColor.whiteColor().CGColor
        
        
        self.locationManager.requestAlwaysAuthorization()
        
        self.locationManager.requestWhenInUseAuthorization()
        
        locationManager.delegate = self;
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.AuthorizedWhenInUse ) {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startRangingBeaconsInRegion(region)
    }
    
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        /*if(beacons.count > 0){
        }*/
        print(beacons)

        if(beacons.count > 0){
            self.performSegueWithIdentifier("nearby", sender: self)
        }

    }
    
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager){
        
        if(peripheral.state == CBPeripheralManagerState.PoweredOn){
            let dict: [String:AnyObject] = self.region.peripheralDataWithMeasuredPower(nil) as! [String:AnyObject]
            periphmanager.startAdvertising(dict)
        }
        print(peripheral.state)
    }
    
    func peripheralManagerDidStartAdvertising(peripheral: CBPeripheralManager, error: NSError?) {
        if error != nil{
            print(error)
        }
        print("Broadcasting!")
    }
    
    /*
    * Initialize the peripheral manager which is responsible for broadcasting
    */
    func beginBroadcasting(){
            self.periphmanager = CBPeripheralManager(delegate: self, queue: nil)
    }

    
    @IBAction func facebookLogin() {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager .logInWithReadPermissions(["email"], handler: { (result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
            }
            
            if (error == nil){
                var fbLoginResult : FBSDKLoginManagerLoginResult! = result
                if(fbLoginResult != nil)
                {
                    if(fbLoginResult.grantedPermissions.contains("email")){
                        self.getUserData()
                        
                        // We ned major and minor
                        // We need to instantiate peripheral manager
                        self.beginBroadcasting()
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
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError){
        print("Error while updating location " + error.localizedDescription)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonPressed(sender: AnyObject) {
        AudioServicesPlayAlertSound(SystemSoundID(4095))
    }
    
    
    
    
    
    
}