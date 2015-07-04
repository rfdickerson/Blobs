//
//  ViewController.swift
//  DrawingSimulation
//
//  Created by Robert Dickerson on 7/4/15.
//  Copyright (c) 2015 Robert Dickerson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var simulationView: SimulationUIView!
    
    var sim : Simulation?
    var startTime = NSDate.timeIntervalSinceReferenceDate()
    var currentTime: NSTimeInterval = 0

    @IBAction func changeGravity(sender: UISlider) {
        sim?.gravity = Double(sender.value)
    }
    
    @IBAction func handleClick(sender: UITapGestureRecognizer) {
        
        if let view = sender.view
        {
            let coords = sender.locationInView( view )
            
            sim?.addBall(Double(coords.x), y: Double(coords.y), mass: 2.0)
        }
        
        simulationView.setNeedsDisplay()
        
        println("Clicked!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sim = Simulation()
        
        simulationView.simulation = sim
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.015, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func update()
    {
        currentTime = NSDate.timeIntervalSinceReferenceDate()
        
        var dt = currentTime - startTime
        sim?.update(dt)
        simulationView.setNeedsDisplay()
        // println(dt)
        
        startTime = currentTime
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

