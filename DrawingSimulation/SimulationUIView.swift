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
    
    let ballScaleSize = 5.0
    
    var simulation : Simulation?
    
    func getBallCoords (x : Double, y: Double, mass: Double) -> (x: CGFloat, y: CGFloat, size: CGFloat)
    {
        let size = ballScaleSize * mass;
        
        let l : Double = x - size/2.0
        let t : Double = y - size/2.0
        
        return (CGFloat(l), CGFloat(t), CGFloat(size))
    }
    
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
                CGContextMoveToPoint(context, CGFloat(spring.ball1.position.x), CGFloat(spring.ball1.position.y))
                CGContextAddLineToPoint(context, CGFloat(spring.ball2.position.x), CGFloat(spring.ball2.position.y))
                
                CGContextStrokePath(context)
            }

            
            for ball in sim.balls
            {
                let x : Double = ball.position.x - ballsize/2.0
                let y : Double = ball.position.y - ballsize/2.0
                
                if (ball.isAnchor)
                {
                    CGContextSetStrokeColorWithColor(context, color2)
                    CGContextSetFillColorWithColor(context, color2)
                } else {
                    CGContextSetStrokeColorWithColor(context, color)
                    CGContextSetFillColorWithColor(context, color)
                }
                
                let (l, t, size) = getBallCoords(ball.position.x, y: ball.position.y, mass: ball.mass)
                
                if ball.isAnchor {
                    let rectangle = CGRectMake(CGFloat(x), CGFloat(y), 20.0, 20.0)
                    
                    CGContextAddEllipseInRect(context, rectangle)
                
                    CGContextFillPath(context)
                }
                else {
                    let rectangle = CGRectMake(l, t, size, size)
                    CGContextAddEllipseInRect(context, rectangle)
                    
                    CGContextFillPath(context)
                }
                
            }
            
                    }
        
        
    }
    

}
