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
    var meters: Float = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func rssiToMeters() {
        if self.rssi > 0 {
            self.meters = 0
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
