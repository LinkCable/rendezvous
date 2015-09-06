//
//  locator.swift
//  Rendezvous
//
//  Created by Philippe Kimura-Thollander on 9/6/15.
//  Copyright © 2015 Philippe Kimura-Thollander. All rights reserved.
//

import UIKit

class locator: UIViewController {

    
    //RSSI[dbm] = −(10n log10(d) − A)
    
    var rssi: Int = 0
    var meters: Double = 0
    var SIGPOWER = -57 //constant rssi @ 1 meter
    @IBOutlet weak var distance: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rssiToMeters()
        dispatch_async(dispatch_get_main_queue(), {
            self.distance.text = String(self.meters * 3) + " feet away!"
        })
    }

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
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
