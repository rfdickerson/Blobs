//
//  Simulation.swift
//  DrawingSimulation
//
//  Created by Robert Dickerson on 7/4/15.
//  Copyright (c) 2015 Robert Dickerson. All rights reserved.
//

import UIKit

public class Simulation {
    
    class Spring
    {
        var ball1: Ball
        var ball2: Ball
        var restLength: Double
        var springiness: Double
        
        init(ball1: Ball, ball2: Ball, springiness: Double = 100.0)
        {
            self.ball1 = ball1
            self.ball2 = ball2
            
            self.springiness = springiness
            
            self.restLength = 1.0
            // self.restLength = mydist(ball1.x, ball1.x, ball2.x, ball2.y)
        }
    }
    
    class Ball
    {
        
        init(x: Double, y: Double, mass: Double, isAnchor: Bool = false)
        {
            self.x = x
            self.y = y
            
            self.xp = 0.0
            self.yp = 0.0
            
            self.mass = mass
            
            self.vx = 0.0
            self.vy = 0.0
            self.fx = 0.0
            self.fy = 0.0
            
            self.isAnchor = isAnchor
        }
        
        var x : Double
        var y : Double
        
        var xp: Double
        var yp: Double
        
        var mass : Double
        
        var vx : Double
        var vy : Double
        
        var fx : Double
        var fy : Double
        
        var isAnchor: Bool
        
    }
    
    var gravity : Double = 9.8
    var distanceThreshold : Double = 50
    
    var damping: Double = 1.0
    public var defaultSpringiness: Double = 100
    public var defaultMass : Double = 3.0
    
    var balls : [Ball]
    var springs : [Spring]
    
    public init ()
    {
        balls = [Ball]()
        springs = [Spring]()
        
        clear()
        //addBall(200, y: 200, isAnchor: true)
    }
    
    public func mydist(x1: Double, y1: Double, x2: Double, y2: Double) -> Double
    {
        
        let dx = (x1 - x2)
        let dy = (y1 - y2)
        
        return sqrt(dx * dx + dy * dy)
    }
    
    public func addBall( x: Double, y: Double, isAnchor: Bool = false)
    {
    
        let mass = isAnchor ? 1e13 : defaultMass
        
        let newball = Ball(x: x, y: y, mass: mass, isAnchor: isAnchor)
        
        var nearby = balls.filter() {
            return self.mydist( $0.x, y1: $0.y, x2: newball.x, y2: newball.y) < self.distanceThreshold
        }
        
        for ball in nearby
        {
            let newspring = Spring(ball1: newball, ball2: ball, springiness: defaultSpringiness)
            
            newspring.restLength = mydist(newball.x, y1: newball.y, x2: ball.x, y2: ball.y)
            springs.append(newspring)
        }
        
        println("Added the ball")
        
        balls.append( newball )
    }
    
    public func clear()
    {
        springs.removeAll(keepCapacity: true)
        balls.removeAll(keepCapacity: true)
        
        addBall(50, y: 100, isAnchor: true)
        addBall(300, y: 100, isAnchor: true)
    }
    
    func updatePosition(ball : Ball, dt: Double)
    {
        let posy = ball.y + ball.vy * dt
        let posx = ball.x + ball.vx * dt
        
        ball.xp = ball.x
        ball.yp = ball.y
        
        ball.x = posx
        ball.y = posy
    }
    
    func updateVelocities(ball: Ball, dt: Double)
    {
        let ax = ball.fx/ball.mass
        let ay = ball.fy/ball.mass
        
        
        
        ball.vx += ax * dt
        ball.vy += ay * dt
        
    }
    
    func forceGravity(ball: Ball)
    {
        if (ball.isAnchor == false) {
            ball.fy += ball.mass * gravity
        }
    }
    
    func forceSpring (spring: Spring, dt: Double)
    {
        let dx = spring.ball2.x - spring.ball1.x
        let dy = spring.ball2.y - spring.ball1.y
        
        let d = mydist(spring.ball1.x, y1: spring.ball1.y,x2: spring.ball2.x, y2: spring.ball2.y)
        let k = spring.springiness/spring.restLength
        let fx = k * (d - spring.restLength) * dx/d
        let fy = k * (d - spring.restLength) * dy/d
        
        let fx1 = damping * ((spring.ball2.x - spring.ball2.xp)/dt - (spring.ball1.x - spring.ball1.xp)/dt)
        let fx2 = damping * ((spring.ball1.x - spring.ball1.xp)/dt - (spring.ball2.x - spring.ball2.xp)/dt)
        let fy1 = damping * ((spring.ball2.y - spring.ball2.yp)/dt - (spring.ball1.y - spring.ball1.yp)/dt)
        let fy2 = damping * ((spring.ball1.y - spring.ball1.yp)/dt - (spring.ball2.y - spring.ball2.yp)/dt)
        
        spring.ball1.fx += fx1
        spring.ball1.fy += fy1
        
        spring.ball2.fx += fx2
        spring.ball2.fy += fy2
        
        spring.ball1.fx += fx
        spring.ball1.fy += fy
        spring.ball2.fx -= fx
        spring.ball2.fy -= fy

    }
    
    func update(dt: Double)
    {
        
        for ball in balls
        {
            ball.fx = 0.0
            ball.fy = 0.0
            
            updatePosition(ball, dt: dt)
        }
        
        for ball in balls
        {
            forceGravity(ball)
        }
        
        for spring in springs
        {
            forceSpring(spring, dt: dt)
        }
        
        for ball in balls
        {
            updateVelocities(ball, dt: dt)
        }
        
        

    }
   
}
