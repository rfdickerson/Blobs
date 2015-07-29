//
//  SimulationUIView.swift
//  DrawingSimulation
//
//  Created by Robert Dickerson on 7/4/15.
//  Copyright (c) 2015 Robert Dickerson. All rights reserved.
//

import UIKit

class SimulationUIView: UIView {

    let ballsize : Double = 10
    
    let ballScaleSize = 5.0
    
    var profileImg = UIImage(named: "ProfilePic.png")
    var bandImg = UIImage(named: "band")
    
    var simulation : Simulation?
    
    var viewportOffset : MILVector = MILVector()
    
    func toViewspace(v: MILVector) -> MILVector
    {
        return ( viewportOffset + v)
    }
    
    func toWorldspace(v: MILVector) -> MILVector
    {
        return (v - viewportOffset)
    }
    
    func getBallCoords (position: MILVector, mass: Double) -> (x: CGFloat, y: CGFloat, size: CGFloat)
    {
        let size = 50.0;
        
        let l : Double = position.x - size/2.0
        let t : Double = position.y - size/2.0
        
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
                let x : Double = ball.position.x - ballsize/2.0
                let y : Double = ball.position.y - ballsize/2.0
                
                let v = MILVector(x: x, y: y)
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
                let rectangle = CGRectMake(CGFloat(nv.x)-32, CGFloat(nv.y)-32, 64.0, 64.0)

                
                if ball.isAnchor {
                    let rectangle = CGRectMake(CGFloat(nv.x)-32, CGFloat(nv.y)-32, 64.0, 64.0)
                    
                    CGContextAddEllipseInRect(context, rectangle)
                
                    //CGContextFillPath(context)
                    // CGContextDrawImage(context, rectangle, profileImg?.CGImage)
                    
                    //CGContextTranslateCTM(context, 0, profileImg!.size.height)
                    //CGContextScaleCTM(context, 1.0, -1.0)
                    //CGContextDrawImage(context, rectangle, profileImg?.CGImage)
                    profileImg?.drawInRect( rectangle)
                    
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
