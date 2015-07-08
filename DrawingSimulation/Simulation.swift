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
            self.position = MILVector(x: x, y: y)
            self.oldPosition = MILVector(x: x, y: y)
            
            self.velocity = MILVector()
            self.force = MILVector()
            
            self.mass = mass
            self.volume = 100.0
            self.charge = 50
            
            self.isAnchor = isAnchor
        }
        
        var position : MILVector
        
        var oldPosition : MILVector
        var mass : Double
        var volume : Double
        var charge : Double
        
        var velocity : MILVector
        var force : MILVector
        
        var isAnchor: Bool
        
    }
    
    var gravity: MILVector = MILVector(x: 0, y: 1)
    
    var gravityAcceleration : Double = 9.8
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
    
    public func addBall( x: Double, y: Double, isAnchor: Bool = false)
    {
    
        let mass = isAnchor ? 1e13 : defaultMass
        
        let newball = Ball(x: x, y: y, mass: mass, isAnchor: isAnchor)
        
        var nearby = balls.filter() {
            // return self.mydist( $0.x, y1: $0.y, x2: newball.x, y2: newball.y) < self.distanceThreshold
            return ($0.position - newball.position).magnitude() < self.distanceThreshold
        }
        
        for ball in nearby
        {
            let newspring = Spring(ball1: newball, ball2: ball, springiness: defaultSpringiness)
            
            //newspring.restLength = mydist(newball.x, y1: newball.y, x2: ball.x, y2: ball.y)
            newspring.restLength = (newball.position - ball.position).magnitude()
            springs.append(newspring)
        }
        
        println("Added the ball")
        
        balls.append( newball )
    }
    
    public func clear()
    {
        springs.removeAll(keepCapacity: true)
        balls.removeAll(keepCapacity: true)
        
        addBall(200, y: 200, isAnchor: true)
        
        for i in 0...12
        {
            let x = 230.0 + Double(i)*30.0
            addBall(x, y: 230, isAnchor: false)
        }
        
        addBall(50, y: 100, isAnchor: true)
        addBall(300, y: 100, isAnchor: true)
    }
    
    func updatePosition(ball : Ball, dt: Double) {
        
        let newposition = ball.position + ball.velocity * dt
        
        ball.oldPosition = ball.position
        
        ball.position = newposition
        
    }
    
    func updateVelocities(ball: Ball, dt: Double)
    {
        let accel = ball.force/ball.mass
        
        ball.velocity = ball.velocity + accel * dt
        
    }
    
    func forceGravity(ball: Ball)
    {
        if (ball.isAnchor == false) {
            
            ball.force = ball.force + gravity * ball.mass * gravityAcceleration
            
        }
    }
    
    func forceCharge(ball: Ball)
    {
        for b in balls
        {
            let r = (ball.position - b.position).magnitude()
            let v = (ball.position - b.position)
            
            if r < 0.1 {
                continue
            }
            
            let f = ball.charge * ball.charge / (r*r)
            // println (f)
            let nv = v * f
            
            ball.force = ball.force + nv
        }
    }
    
    func forceSpring (spring: Spring, dt: Double)
    {
        let dx = spring.ball2.position.x - spring.ball1.position.x
        let dy = spring.ball2.position.y - spring.ball1.position.y
        
        let d = (spring.ball1.position - spring.ball2.position).magnitude()
        
        let k = spring.springiness/spring.restLength
        let fx = k * (d - spring.restLength) * dx/d
        let fy = k * (d - spring.restLength) * dy/d
        
        let fx1 = damping * ((spring.ball2.position.x - spring.ball2.oldPosition.x)/dt - (spring.ball1.position.x - spring.ball1.oldPosition.x)/dt)
        let fx2 = damping * ((spring.ball1.position.x - spring.ball1.oldPosition.x)/dt - (spring.ball2.position.x - spring.ball2.oldPosition.x)/dt)
        let fy1 = damping * ((spring.ball2.position.y - spring.ball2.oldPosition.y)/dt - (spring.ball1.position.y - spring.ball1.oldPosition.y)/dt)
        let fy2 = damping * ((spring.ball1.position.y - spring.ball1.oldPosition.y)/dt - (spring.ball2.position.y - spring.ball2.oldPosition.y)/dt)
        
        spring.ball1.force.x += fx1
        spring.ball1.force.y += fy1
        
        spring.ball2.force.x += fx2
        spring.ball2.force.y += fy2
        
        spring.ball1.force.x += fx
        spring.ball1.force.y += fy
        spring.ball2.force.x -= fx
        spring.ball2.force.y -= fy

    }
    
    func hasCollision(ball: Ball) -> Bool
    {
        return ball.position.y > 300
    }
    
    func forceCollision(ball: Ball, dt: Double)
    {
        // let j = -ball.mass*ball.vy*2
        // ball.fy = j/dt
    }
    
    func update(dt: Double)
    {
        
        for ball in balls
        {
            ball.force = MILVector()
            
            updatePosition(ball, dt: dt)
        }
        
        for ball in balls
        {
            if hasCollision(ball)
            {
                forceCollision(ball, dt: dt)
            }
            
            forceCharge(ball)
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
