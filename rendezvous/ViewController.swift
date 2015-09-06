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

class ViewController: UIViewController, CLLocationManagerDelegate{
    
    @IBOutlet weak var rSubtitle: UILabel!
    @IBOutlet weak var rTitle: UILabel!

    @IBOutlet weak var facebook: UIButton!
    @IBOutlet weak var contacts: UIButton!
    
    let locationManager = CLLocationManager()
    let appuid: String! = "29B1AD96-1DF0-4392-8C8A-7387F9E7BD84"
    var region = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "29B1AD96-1DF0-4392-8C8A-7387F9E7BD84")!, identifier: "Ya Boi")
    
    var uname: NSString = ""
    var id: NSString = ""
    var result: NSString = ""
    var friends: NSArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.AuthorizedWhenInUse) {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startRangingBeaconsInRegion(region)
        
        
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            // User is already logged in, do work such as go to next view controller.
            getUserData()
        }
    }
    
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        print(beacons)
    }
    
    @IBAction func facebookLogin() {
        var fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
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
        
        var fbRequest = FBSDKGraphRequest(graphPath:"/me/friends", parameters: nil);
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
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*
    func sendDataToServer(lat: String, long: String, id: NSString, uname: NSString){
    
    var request = NSMutableURLRequest(URL: NSURL(string: "http://104.131.188.22:3001/items")!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5)
    
    var response: NSURLResponse?
    
    
    
    // create some JSON data and configure the request
    
    let jsonString = "json={\"lat\":\"\(lat)\",\"long\":\"\(long)\",\"id\":\"\(id)\",\"uname\":\"\(uname)\"}"
    
    request.HTTPBody = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
    
    request.HTTPMethod = "POST"
    
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    
    print(jsonString)
    
    
    // send the request
    
    do{
    
    try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)
    
    }catch let error as NSError{
    
    print(error)
    
    }
    
    
    
    // look at the response
    
    //print("The response: \(response)")
    
    if let httpResponse = response as? NSHTTPURLResponse {
    
    // print("HTTP response: \(httpResponse.statusCode)")
    
    } else {
    
    print("No HTTP response")
    
    }
    
    }
    
    
    func getDataFromServer(){
    
    let url = NSURL(string: "http://104.131.188.22:3000")
    
    let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
    
    // Handle response here!
    //print(NSString(data: data!, encoding: NSUTF8StringEncoding))
    
    }
    
    task.resume()
    
    }

*/

}