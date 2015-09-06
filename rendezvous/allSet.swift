//
//  allSet.swift
//  Rendezvous
//
//  Created by Philippe Kimura-Thollander on 9/6/15.
//  Copyright © 2015 Philippe Kimura-Thollander. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreBluetooth

class allSet: UIViewController, CLLocationManagerDelegate, CBPeripheralManagerDelegate {

    var uname: NSString = ""
    var id: NSString = ""
    var result: NSString = ""
    var friends: NSArray = []
    
    let locationManager = CLLocationManager()
    let appuid: String! = "29B1AD96-1DF0-4392-8C8A-7387F9E7BD84"
    var region = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "29B1AD96-1DF0-4392-8C8A-7387F9E7BD84")!, identifier: "")
    var periphmanager: CBPeripheralManager! = nil
    var rssi: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.locationManager.requestAlwaysAuthorization()
        
        self.locationManager.requestWhenInUseAuthorization()
        
        locationManager.delegate = self;
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.AuthorizedWhenInUse ) {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startRangingBeaconsInRegion(region)
        
        beginBroadcasting()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue == "nearby"){
            let destinationVC:locator = segue.destinationViewController as! locator
            destinationVC.rssi = self.rssi
        }
    }
    
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
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

    func locationManager(manager: CLLocationManager, didFailWithError error: NSError){
        print("Error while updating location " + error.localizedDescription)
    }

}
