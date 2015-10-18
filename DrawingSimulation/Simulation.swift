//
//  Simulation.swift
//  DrawingSimulation
//
//  Created by Robert Dickerson on 7/4/15.
//  Copyright (c) 2015 Robert Dickerson. All rights reserved.
//

import UIKit
import simd

public class Simulation {
    
    class Spring
    {
        var ball1: Ball
        var ball2: Ball
        var restLength: Float
        var springiness: Float
        
        init(ball1: Ball, ball2: Ball, springiness: Float = 100.0)
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
        
        init(x: Float, y: Float, mass: Float, isAnchor: Bool = false)
        {
            self.position = float2(x, y)
            self.oldPosition = float2(x, y)
            
            self.velocity = float2(0,0)
            self.force = float2(0,0)
            
            self.mass = mass
            self.volume = 100.0
            self.charge = 0.0
            self.size = 20.0
            
            self.isAnchor = isAnchor
        }
        
        
        var size : Float!
        var position : float2
        var oldPosition : float2
        
        var mass : Float
        var volume : Float
        var charge : Float
        
        var velocity : float2
        var force : float2
        
        var isAnchor: Bool
        
    }
    
    var gravity: float2 = float2(0, 1)
    
    var gravityAcceleration : Float = 9.8
    var distanceThreshold : Float = 50
    
    var damping: Float = 1.0
    public var defaultSpringiness: Float = 100
    public var defaultMass : Float = 3.0
    
    var balls : [Ball]
    var springs : [Spring]
    
    public init ()
    {
        balls = [Ball]()
        springs = [Spring]()
        
        clear()
        
    }
    
    public func addBall( x: Float, y: Float, isAnchor: Bool = false)
    {
    
        let mass = isAnchor ? 1e13 : defaultMass
        
        let newball = Ball(x: x, y: y, mass: mass, isAnchor: isAnchor)
        
        let nearby = balls.filter() {
            // return self.mydist( $0.x, y1: $0.y, x2: newball.x, y2: newball.y) < self.distanceThreshold
            return norm_one($0.position - newball.position) < self.distanceThreshold
        }
        
        for ball in nearby
        {
            let newspring = Spring(ball1: newball, ball2: ball, springiness: defaultSpringiness)
            
            //newspring.restLength = mydist(newball.x, y1: newball.y, x2: ball.x, y2: ball.y)
            newspring.restLength = norm_one(newball.position - ball.position)
            springs.append(newspring)
        }
        
        print("Added the ball")
        
        balls.append( newball )
    }
    
    public func clear()
    {
        springs.removeAll(keepCapacity: true)
        balls.removeAll(keepCapacity: true)
        
        addBall(50, y: 200, isAnchor: true)
        addBall(300, y: 200, isAnchor: true)
        
    }
    
    func approxDerivative (x: Float, f : (Float->Float)) -> Float
    {
      
        let dx = 0.001 * x
        let dy = f (x + dx) - f (x - dx)
        
        return dy/(2*dx)
    }
    
    public func eulerMethod (f : (Float->Float), y0: Float, h: Float) -> Float
    {
        return y0 + h * f (y0)
    }
    
    public func implicitEuler (f: (Float->Float), y0: Float, h: Float) -> Float
    {
        let guess = eulerMethod ( f, y0: y0, h: h)
        let g = {x in x - y0 - h*f(x)}
        return newtonRaphson(guess, f: g)
    }
    
    
    func newtonRaphson (guess: Float, f : (Float->Float)) -> Float
    {
        if isnan(guess)
        {
            assert(false)
        }
        
        let epsilon : Float = 0.001
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

    
    func updatePosition(ball : Ball, dt: Float) {
        
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
    
    func updateVelocities(ball: Ball, dt: Float)
    {
        let accel = ball.force * (1/ball.mass)
        
        // ball.velocity = ball.velocity + accel * dt
        
        // let fx = {x in accel.x*x}
        // let fy = {x in accel.y*x}
        
        func fx (x: Float) -> Float
        {
            return accel.x
        }
        
        func fy (y: Float) -> Float
        {
            return accel.y
        }
        
        // let xp = implicitEuler(fx, y0: ball.velocity.x, h: dt)
        // let yp = implicitEuler(fy, y0: ball.velocity.y, h: dt)
        
        let xp = eulerMethod(fx, y0: ball.velocity.x, h: dt)
        let yp = eulerMethod(fy, y0: ball.velocity.y, h: dt)
        
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
            let r = norm_one(ball.position - b.position)
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
    
    func forceSpring (spring: Spring, dt: Float)
    {
        let dx = spring.ball2.position.x - spring.ball1.position.x
        let dy = spring.ball2.position.y - spring.ball1.position.y
        
        let d = norm_one(spring.ball1.position - spring.ball2.position)
        
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
    
    func forceCollision(ball: Ball, dt: Float)
    {
        // let j = -ball.mass*ball.vy*2
        // ball.fy = j/dt
    }
    
    func update(dt: Float)
    {
        
        for ball in balls
        {
            ball.force = float2(0,0)
            
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
