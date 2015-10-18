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
            self.position = Vector2D(x: x, y: y)
            self.oldPosition = Vector2D(x: x, y: y)
            
            self.velocity = Vector2D()
            self.force = Vector2D()
            
            self.mass = mass
            self.volume = 100.0
            self.charge = 0.0
            self.size = 20.0
            
            self.isAnchor = isAnchor
        }
        
        
        var size : Double!
        var position : Vector2D
        
        var oldPosition : Vector2D
        var mass : Double
        var volume : Double
        var charge : Double
        
        var velocity : Vector2D
        var force : Vector2D
        
        var isAnchor: Bool
        
    }
    
    var gravity: Vector2D = Vector2D(x: 0, y: 1)
    
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
        
    }
    
    public func addBall( x: Double, y: Double, isAnchor: Bool = false)
    {
    
        let mass = isAnchor ? 1e13 : defaultMass
        
        let newball = Ball(x: x, y: y, mass: mass, isAnchor: isAnchor)
        
        let nearby = balls.filter() {
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
        
        print("Added the ball")
        
        balls.append( newball )
    }
    
    public func clear()
    {
        springs.removeAll(keepCapacity: true)
        balls.removeAll(keepCapacity: true)
        
        // addBall(200, y: 200, isAnchor: true)
        addBall(50, y: 200, isAnchor: true)
        addBall(300, y: 200, isAnchor: true)
        
    }
    
    func approxDerivative (x: Double, f : (Double->Double)) -> Double
    {
      
        let dx = 0.001 * x
        let dy = f (x + dx) - f (x - dx)
        
        return dy/(2*dx)
    }
    
    public func eulerMethod (f : (Double->Double), y0: Double, h: Double) -> Double
    {
        return y0 + h * f (y0)
    }
    
    public func implicitEuler (f: (Double->Double), y0: Double, h: Double) -> Double
    {
        let guess = eulerMethod ( f, y0: y0, h: h)
        let g = {x in x - y0 - h*f(x)}
        return newtonRaphson(guess, f: g)
    }
    
    
    func newtonRaphson (guess: Double, f : (Double->Double)) -> Double
    {
        if isnan(guess)
        {
            assert(false)
        }
        
        let epsilon = 0.001
        let fprime = approxDerivative(guess, f: f)
        if fprime == 0 || isnan(fprime)
        {
            return 0
        }
        
        let newGuess = guess - f (guess) / fprime
        let difference = abs(newGuess - guess)
        
        if difference <= epsilon {
            return newGuess
        } else {
            return newtonRaphson(newGuess, f: f)
        }
    }

    
    func updatePosition(ball : Ball, dt: Double) {
        
        let newposition = ball.position + ball.velocity * dt
        
        ball.oldPosition = ball.position
        
        /**
        
        func fx (x: Double) -> Double
        {
            return ball.velocity.x
        }
        
        func fy (y: Double) -> Double
        {
            return ball.velocity.y
        }
        
        let xp = implicitEuler(fx, y0: ball.oldPosition.x, h: dt)
        let yp = implicitEuler(fy, y0: ball.oldPosition.y, h: dt)
        **/
        
        ball.position = newposition
        
        // ball.position.x = xp
        // ball.position.y = yp
        
    }
    
    func updateVelocities(ball: Ball, dt: Double)
    {
        let accel = ball.force/ball.mass
        
        // ball.velocity = ball.velocity + accel * dt
        
        // let fx = {x in accel.x*x}
        // let fy = {x in accel.y*x}
        
        func fx (x: Double) -> Double
        {
            return accel.x
        }
        
        func fy (y: Double) -> Double
        {
            return accel.y
        }
        
        let xp = implicitEuler(fx, y0: ball.velocity.x, h: dt)
        let yp = implicitEuler(fy, y0: ball.velocity.y, h: dt)
        
        ball.velocity.x = xp
        ball.velocity.y = yp
        
    }
    
    func forceGravity(ball: Ball)
    {
        if ball.isAnchor == false {
            
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
            ball.force = Vector2D()
            
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
