//
//  Simulation.swift
//  DrawingSimulation
//
//  Created by Robert Dickerson on 7/4/15.
//  Copyright (c) 2015 Robert Dickerson. All rights reserved.
//

import UIKit

public class Simulation {
    
    class Ball
    {
        
        init(x: Double, y: Double, mass: Double)
        {
            self.x = x
            self.y = y
            self.mass = mass
            
            self.vx = 0.0
            self.vy = 0.0
            self.fx = 0.0
            self.fy = 0.0
        }
        
        var x : Double
        var y : Double
        
        var mass : Double
        
        var vx : Double
        var vy : Double
        
        var fx : Double
        var fy : Double
        
    }
    
    var gravity : Double = 9.8
    
    var balls : [Ball]
    
    public init ()
    {
        balls = [Ball]()
    }
    
    public func addBall( x: Double, y: Double, mass: Double)
    {
    
        let ball = Ball(x: x, y: y, mass: mass)
        
        balls.append( ball )
        
        println("Added the ball")
    }
    
    func updatePosition(ball : Ball, dt: Double)
    {
        let posy = ball.y + ball.vy * dt
        let posx = ball.x + ball.vx * dt
        
        ball.x = posx
        ball.y = posy
    }
    
    func updateVelocities(ball: Ball, dt: Double)
    {
        let ax = ball.fx/ball.mass
        let ay = ball.fy/ball.mass
        
        let vx = ball.vx + ax * dt
        let vy = ball.vy + ay * dt
        
        ball.vx = vx
        ball.vy = vy
        
    }
    
    func forceGravity(ball: Ball)
    {
        ball.fy += ball.mass * gravity
    }
    
    func update(dt: Double)
    {
        for ball in balls
        {
            updatePosition(ball, dt: dt)
        }
        
        for ball in balls
        {
            forceGravity(ball)
        }
        
        for ball in balls
        {
            updateVelocities(ball, dt: dt)
        }
        
        

    }
   
}
