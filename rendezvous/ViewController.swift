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


class ViewController: UIViewController {
    @IBOutlet weak var VibrateButton: UIButton!
    @IBOutlet weak var map: MKMapView!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("Hello world")
        
        
        self.locationManager.requestAlwaysAuthorization()
        
        self.locationManager.requestWhenInUseAuthorization()
        
        if(CLLocationManager.locationServicesEnabled()){
            //locationManager.delegate = self
            //locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            //locationManager.requestAlwaysAuthorization()
            //locationManager.startUpdatingLocation()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonPressed(sender: AnyObject) {
        AudioServicesPlayAlertSound(SystemSoundID(4095))
    }

}

