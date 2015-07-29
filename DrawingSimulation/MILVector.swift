//
//  MILVector.swift
//  DrawingSimulation
//
//  Created by Robert Dickerson on 7/7/15.
//  Copyright (c) 2015 Robert Dickerson. All rights reserved.
//

import UIKit

func +(left: MILVector, right: MILVector) -> MILVector
{
    var new = MILVector(x: left.x, y: left.y)
    new.x += right.x
    new.y += right.y
    
    return new
}

func -(left: MILVector, right: MILVector) -> MILVector
{
    var new = MILVector(x: left.x, y: left.y)
    new.x -= right.x
    new.y -= right.y
    return new
}

func *(left: MILVector, right: Double) -> MILVector
{
    var new = MILVector(x: left.x, y: left.y);
    new.x *= right;
    new.y *= right;
    return new
}

func /(left: MILVector, right: Double) -> MILVector
{
    var new = MILVector(x: left.x, y: left.y);
    new.x /= right;
    new.y /= right;
    return new
}

public class MILVector {
    
    var x : Double
    var y : Double
    
    public init () {
        self.x = 0.0
        self.y = 0.0
    }
    
    public init (x: Double, y: Double)
    {
        self.x = x
        self.y = y
    }
    
    func dot (a: MILVector, b: MILVector) -> Double
    {
        return 0.0
    }
    
    func norm () -> MILVector
    {
        var new = MILVector()
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
