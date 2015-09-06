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

class locator: UIViewController, CLLocationManagerDelegate {

    
    //RSSI[dbm] = −(10n log10(d) − A)
    
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
    
    /**
    func rssiToMeters() {
        if self.rssi > 0 {
            self.meters = 0
        }
        let ratio: Double = Double(Float(rssi)/Float(self.SIGPOWER));
        
        if (ratio < 1.0) {
            self.meters = pow(ratio,10);
        }
        else {
            self.meters =  (0.89976) * pow(ratio,7.7095) + 0.111;
        }
        feet = meters * 3
    }*/
    
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        print(beacons)
        
        if(beacons.count > 0){
            self.meters = beacons[0].accuracy;
            self.feet = self.meters * 3
        }
        
        if self.feet < 0 {
            self.feet = 0
        }
        
        print(self.meters)
        print(self.feet)
        
        dispatch_async(dispatch_get_main_queue(), {
            let convertedStr: String = NSString(format: "%.2f", self.feet) as String
            self.distance.text = convertedStr + " feet away"
        })
    }

}
