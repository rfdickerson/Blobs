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
    var timer : NSTimer?

    
    @IBAction func handleSimRun(switchState: UISwitch) {
        if switchState.on {
            timer = NSTimer.scheduledTimerWithTimeInterval(0.005, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
        } else {
            timer?.invalidate()
        }
    }
    
    @IBAction func changeGravity(sender: UISlider) {
        sim?.gravity = Double(sender.value)
    }
    
    @IBAction func handleChangeMass(sender: UISlider) {
        sim?.defaultMass = Double(sender.value)
    }
    
    @IBAction func handleChangleElasticity(sender: UISlider) {
        
        sim?.defaultSpringiness = Double(sender.value)
    }
    
    @IBAction func handleClick(sender: UITapGestureRecognizer) {
        
        if let view = sender.view
        {
            let coords = sender.locationInView( view )
            
            sim?.addBall(Double(coords.x), y: Double(coords.y))
        }
        
        simulationView.setNeedsDisplay()
        
        println("Clicked!")
    }
    
    @IBAction func handleClearScene(sender: AnyObject) {
        sim?.clear()
        
        simulationView.setNeedsDisplay()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sim = Simulation()
        
        simulationView.simulation = sim
        
        timer = NSTimer.scheduledTimerWithTimeInterval(0.005, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    func update()
    {
        currentTime = NSDate.timeIntervalSinceReferenceDate()
        
        var dt = currentTime - startTime
        
        if dt < 0.1 {
            sim?.update(dt*10)
            simulationView.setNeedsDisplay()
        }
        // println(dt)
        
        startTime = currentTime
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

