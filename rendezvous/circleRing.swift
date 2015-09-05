//
//  circleRing.swift
//  rendezvous
//
//  Created by Philippe Kimura-Thollander on 9/5/15.
//  Copyright © 2015 Philippe Kimura-Thollander. All rights reserved.
//

import UIKit

class circleRing: UIView {

    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // 1
        let center = CGPoint(x:bounds.width/2, y: bounds.height/2)
        
        // 3
        let arcWidth: CGFloat = 20
        
        // 4
        let startAngle: CGFloat = 0
        let endAngle: CGFloat = 360
        
        // 5
        let path = UIBezierPath(arcCenter: center,
            radius: 70 - arcWidth/2,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true)
        
        // 6
        path.lineWidth = arcWidth
        UIColor.whiteColor().colorWithAlphaComponent(0.6).setStroke()
        path.stroke()
    }
    

}
