//
//  Vector2D.swift
//  DrawingSimulation
//
//  Created by Robert Dickerson on 7/7/15.
//  Copyright (c) 2015 Robert Dickerson. All rights reserved.
//

import UIKit

public func +(left: Vector2D, right: Vector2D) -> Vector2D
{
    let new = Vector2D(x: left.x, y: left.y)
    new.x += right.x
    new.y += right.y
    
    return new
}

public func -(left: Vector2D, right: Vector2D) -> Vector2D
{
    let new = Vector2D(x: left.x, y: left.y)
    new.x -= right.x
    new.y -= right.y
    return new
}

public func *(left: Vector2D, right: Double) -> Vector2D
{
    let new = Vector2D(x: left.x, y: left.y);
    new.x *= right;
    new.y *= right;
    return new
}

public func /(left: Vector2D, right: Double) -> Vector2D
{
    let new = Vector2D(x: left.x, y: left.y);
    new.x /= right;
    new.y /= right;
    return new
}

public class Vector2D {
    
    public var x : Double
    public var y : Double
    
    public init () {
        self.x = 0.0
        self.y = 0.0
    }
    
    public init (x: Double, y: Double)
    {
        self.x = x
        self.y = y
    }
    
    func dot (a: Vector2D, b: Vector2D) -> Double
    {
        return a.x * b.x + a.y * b.y
    }
    
    func norm () -> Vector2D
    {
        let new = Vector2D()
        let mag = self.magnitude()
        new.x = self.x / mag
        new.y = self.y / mag
        return new
    }
    
    func magnitude () -> Double
    {
        return sqrt(self.x*self.x + self.y*self.y)
    }
    
    func zero ()
    {
        self.x = 0.0
        self.y = 0.0
    }
    
    
   
}
