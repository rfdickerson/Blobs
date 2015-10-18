//
//  SimulationUIView.swift
//  DrawingSimulation
//
//  Created by Robert Dickerson on 7/4/15.
//  Copyright (c) 2015 Robert Dickerson. All rights reserved.
//

import UIKit
import simd

class SimulationUIView: UIView {

    let ballsize : Float = 20.0
    
    let ballScaleSize = 2.0
    
    var simulation : Simulation?
    
    var viewportOffset : float2 = float2(0,0)
    
    func toViewspace(v: float2) -> float2
    {
        return ( viewportOffset + v)
    }
    
    func toWorldspace(v: float2) -> float2
    {
        return (v - viewportOffset)
    }
    
    func getBallCoords (position: float2, mass: Float)
        -> (x: CGFloat, y: CGFloat, size: CGFloat)
    {
        let size = ballsize;
        
        let l : Float = position.x - size/2.0
        let t : Float = position.y - size/2.0
        
        return (CGFloat(l), CGFloat(t), CGFloat(size))
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 2.0)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let components: [CGFloat] = [0.0, 0.0, 0.0, 1.0]
        let components2: [CGFloat] = [0.0, 0.0, 0.0, 1.0]
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
                
                let v1 = toWorldspace(spring.ball1.position)
                let v2 = toWorldspace(spring.ball2.position)
                
                CGContextMoveToPoint(context, CGFloat(v1.x), CGFloat(v1.y))
                CGContextAddLineToPoint(context, CGFloat(v2.x), CGFloat(v2.y))
                
                CGContextStrokePath(context)
            }

            
            for ball in sim.balls
            {
                let x : Float = ball.position.x - ballsize/2.0
                let y : Float = ball.position.y - ballsize/2.0
                
                let v = float2(x: x, y: y)
                let nv = toWorldspace(v)
                
                if (ball.isAnchor)
                {
                    CGContextSetStrokeColorWithColor(context, color2)
                    CGContextSetFillColorWithColor(context, color2)
                } else {
                    CGContextSetStrokeColorWithColor(context, color)
                    CGContextSetFillColorWithColor(context, color)
                }
                
                //let (l, t, size) = getBallCoords(ball, mass: ball.mass)
                let rectangle = CGRectMake(CGFloat(nv.x), CGFloat(nv.y), CGFloat(ball.size), CGFloat(ball.size))

                
                if ball.isAnchor {
                    // let rectangle = CGRectMake(CGFloat(nv.x)-32, CGFloat(nv.y)-32, 64.0, 64.0)
                    
                    CGContextAddEllipseInRect(context, rectangle)
                
                    CGContextFillPath(context)
                    // CGContextDrawImage(context, rectangle, profileImg?.CGImage)
                    
                    //CGContextTranslateCTM(context, 0, profileImg!.size.height)
                    //CGContextScaleCTM(context, 1.0, -1.0)
                    //CGContextDrawImage(context, rectangle, profileImg?.CGImage)
                    // profileImg?.drawInRect( rectangle)
                    
                    CGContextStrokeEllipseInRect(context, rectangle)
                }
                else {
                    //let rectangle = CGRectMake(l, t, size, size)
                    CGContextAddEllipseInRect(context, rectangle)
                    
                    CGContextFillPath(context)
                    
                    //bandImg?.drawInRect(rectangle)
                }
                
            }
            
                    }
        
        
    }
    

}
