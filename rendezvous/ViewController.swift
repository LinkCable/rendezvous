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




class ViewController: UIViewController, CLLocationManagerDelegate, FBSDKLoginButtonDelegate{
    @IBOutlet weak var VibrateButton: UIButton!
    
    let locationManager = CLLocationManager()
    
    var uname: NSString = ""
    var id: NSString = ""
    var result: NSString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("Hello world")
        
        let label : UILabel = UILabel(frame: CGRectMake(0, 0, self.view.frame.size.width, 120))
        label.textAlignment = NSTextAlignment.Center
        label.text = "rendezvous"
        label.font = UIFont(name: "Quicksand-Regular", size: 48)
        label.textColor = UIColor.whiteColor()
        self.view.addSubview(label)
        
        
        self.locationManager.requestAlwaysAuthorization()
        
        self.locationManager.requestWhenInUseAuthorization()
        
        if(CLLocationManager.locationServicesEnabled()){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            // User is already logged in, do work such as go to next view controller.
            getUserData()
        }
        else
        {
            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            self.view.addSubview(loginView)
            loginView.center = self.view.center
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
            loginView.delegate = self
        }
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")
        
        if ((error) != nil)
        {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                getUserData()
            }
        }
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
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
        
        
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        
        
        let center = CLLocationCoordinate2D(latitude: locValue.latitude, longitude: locValue.longitude)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        
        
        //self.map.setRegion(region, animated: false)
        
        
        
        sendDataToServer("\(locValue.latitude)",long:"\(locValue.longitude)", result: "\(self.result)")
        getDataFromServer()
        
    }
    
    func sendDataToServer(lat: String, long: String, result: NSString){
        
        var request = NSMutableURLRequest(URL: NSURL(string: "http://104.131.188.22:3000/items")!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5)
        
        var response: NSURLResponse?
        
        
        
        // create some JSON data and configure the request
        
        let jsonString = "json=[{\"lat\":\"\(lat)\",\"long\":\"\(long)\",\"result\":\"\(result)\"}]"
        
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
            
            //print("HTTP response: \(httpResponse.statusCode)")
            
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

