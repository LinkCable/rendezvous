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
    @IBOutlet weak var VibrateButton: UIButton!
    
    let locationManager = CLLocationManager()
    
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
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        
        var locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
        
        
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        
        
        let center = CLLocationCoordinate2D(latitude: locValue.latitude, longitude: locValue.longitude)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        
        
        //self.map.setRegion(region, animated: false)
        
        
        
        sendDataToServer("\(locValue.latitude)",long:"\(locValue.latitude)")
        getDataFromServer()
        
    }
    
    func sendDataToServer(lat: String, long: String){
        
        var request = NSMutableURLRequest(URL: NSURL(string: "http://104.131.188.22:3000/items")!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5)
        
        var response: NSURLResponse?
        
        
        
        // create some JSON data and configure the request
        
        let jsonString = "json=[{\"lat\":\"\(lat)\",\"long\":\"\(long)\"}]"
        
        request.HTTPBody = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        
        request.HTTPMethod = "POST"
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        
        
        // send the request
        
        do{
            
            try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)
            
        }catch let error as NSError{
            
            print(error)
            
        }
        
        
        
        // look at the response
        
        print("The response: \(response)")
        
        if let httpResponse = response as? NSHTTPURLResponse {
            
            print("HTTP response: \(httpResponse.statusCode)")
            
        } else {
            
            print("No HTTP response")
            
        }
        
    }
    
    
    
    func getDataFromServer(){
        
        let url = NSURL(string: "http://104.131.188.22:3000")
        
        
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            
            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
            
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

