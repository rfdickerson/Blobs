//
//  SimulationUIView.swift
//  DrawingSimulation
//
//  Created by Robert Dickerson on 7/4/15.
//  Copyright (c) 2015 Robert Dickerson. All rights reserved.
//

import UIKit

class SimulationUIView: UIView {

    let ballsize : Double = 20
    
    var simulation : Simulation?
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 2.0)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let components: [CGFloat] = [0.0, 0.0, 1.0, 1.0]
        let components2: [CGFloat] = [1.0, 0.0, 1.0, 1.0]
        let color = CGColorCreate(colorSpace, components)
        let color2 = CGColorCreate(colorSpace, components2)
        
        CGContextSetStrokeColorWithColor(context, color)
        CGContextSetFillColorWithColor(context, color)
        
        //CGContextMoveToPoint(context, 20, 30)
        //CGContextAddLineToPoint(context, 300, 400)
        
        // CGContextStrokePath(context)
        
        if let sim = simulation
        {
            
            for spring in sim.springs
            {
                CGContextMoveToPoint(context, CGFloat(spring.ball1.x), CGFloat(spring.ball1.y))
                CGContextAddLineToPoint(context, CGFloat(spring.ball2.x), CGFloat(spring.ball2.y))
                
                CGContextStrokePath(context)
            }

            
            for ball in sim.balls
            {
                let x : Double = ball.x - ballsize/2
                let y : Double = ball.y - ballsize/2
                
                if (ball.isAnchor)
                {
                    CGContextSetStrokeColorWithColor(context, color2)
                    CGContextSetFillColorWithColor(context, color2)
                } else {
                    CGContextSetStrokeColorWithColor(context, color)
                    CGContextSetFillColorWithColor(context, color)
                }
                
                
                let rectangle = CGRectMake(CGFloat(x), CGFloat(y), 20.0, 20.0)
                CGContextAddEllipseInRect(context, rectangle)
                // CGContextStrokePath(context)
                CGContextFillPath(context)
            }
            
                    }
        
        
    }
    

}
