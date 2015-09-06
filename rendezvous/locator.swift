//
//  locator.swift
//  Rendezvous
//
//  Created by Philippe Kimura-Thollander on 9/6/15.
//  Copyright © 2015 Philippe Kimura-Thollander. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreBluetooth
import AudioToolbox
import Foundation

class locator: UIViewController, CLLocationManagerDelegate {
    
    var rssi: Int = 0
    var meters: Double = 0
    var feet : Double = 0
    var SIGPOWER = -57 //constant rssi @ 1 meter
    @IBOutlet weak var distance: UILabel!
    
    let locationManager = CLLocationManager()
    var region = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "29B1AD96-1DF0-4392-8C8A-7387F9E7BD84")!, identifier: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.requestAlwaysAuthorization()
        
        self.locationManager.requestWhenInUseAuthorization()
        
        locationManager.delegate = self;
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.AuthorizedWhenInUse ) {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startRangingBeaconsInRegion(region)
    }
    
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        print(beacons)
        
        if(beacons.count > 0){
            self.meters = beacons[0].accuracy;
            self.feet = self.meters * 3
        }
        
        //var vibrateTimer: NSTimer! = nil

        
        if self.feet < 0 {
            self.feet = 0
        }
        
        if(self.feet < 16){
            vibrate()
        }
        print(self.meters)
        print(self.feet)
        
        dispatch_async(dispatch_get_main_queue(), {
            let convertedStr: String = NSString(format: "%.2f", self.feet) as String
            self.distance.text = convertedStr + " feet away"
        })
    }
    
    func vibrate(){
        AudioServicesPlayAlertSound(4095);
    }

}
