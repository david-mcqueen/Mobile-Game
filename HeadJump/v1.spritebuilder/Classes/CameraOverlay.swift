//
//  CameraOverlay.swift
//  v1
//
//  Created by David McQueen on 14/07/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import UIKit

class CameraOverlayView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Initialization code
        backgroundColor = UIColor.clearColor()
        userInteractionEnabled = false
    }
    

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
        // Drawing code
        
        // draws lines and curves to make shapes
        let path = UIBezierPath()
        
        let topCrosshair = CGPoint(x: center.x, y: center.y + 10.0)
        let rightCrosshair = CGPoint(x: center.x + 10.0, y: center.y)
        let bottomCrosshair = CGPoint(x: center.x, y: center.y - 10.0)
        let leftCrosshair = CGPoint(x: center.x - 10.0, y: center.y)
        
        // "pick up" the path and move it to the correct point, then draw across
        path.moveToPoint(topCrosshair)
        path.addLineToPoint(bottomCrosshair)
        path.moveToPoint(leftCrosshair)
        path.addLineToPoint(rightCrosshair)
        
        
        path.lineWidth = 1.0
        
        // Close to the yellow used in the Camera app
        UIColor(red: 255.0, green: 204.0, blue: 0.0, alpha: 1.0).setStroke()
        
        path.stroke()
        
        
        
        
        var bezierPath: UIBezierPath = UIBezierPath();
        bezierPath.addArcWithCenter(CGPoint(x: UIViewController().view.bounds.width / 2, y: UIViewController().view.bounds.height / 2),
            radius: CGFloat(UIViewController().view.bounds.width / 2),
            startAngle: CGFloat(0),
            endAngle: CGFloat(2 * M_PI),
            clockwise: true);
        
        
        
        bezierPath.stroke();
    }
    
}