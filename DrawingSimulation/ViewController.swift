//
//  ViewController.swift
//  DrawingSimulation
//
//  Created by Robert Dickerson on 7/4/15.
//  Copyright (c) 2015 Robert Dickerson. All rights reserved.
//

import UIKit
import CoreMotion
import simd

class ViewController: UIViewController {

    @IBOutlet weak var simulationView: SimulationUIView!
    
    let updateInterval = 0.0005
    
    var sim : Simulation?
    var startTime = NSDate.timeIntervalSinceReferenceDate()
    var currentTime: NSTimeInterval = 0
    var timer : NSTimer?
    var motionManager : CMMotionManager?
    var panBegin : float2?

    override func shouldAutorotate() -> Bool {
        return false
    }
    
    @IBAction func handleSimRun(switchState: UISwitch) {
        if switchState.on {
            timer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
        } else {
            timer?.invalidate()
        }
    }
    
    @IBAction func changeGravity(sender: UISlider) {
        sim?.gravityAcceleration = Float(sender.value)
    }
    
    @IBAction func handleChangeMass(sender: UISlider) {
        sim?.defaultMass = Float(sender.value)
    }
    
    @IBAction func handlePan(sender: UIPanGestureRecognizer) {
        if let view = sender.view as? SimulationUIView
        {
            let coords = sender.translationInView(view)
            let c = float2(x: Float(coords.x), y: Float(coords.y))
            
            
            if sender.state == UIGestureRecognizerState.Began
            {
               panBegin = c
            }
            
            let offset = c - panBegin!
            
            // println(coords)
            
            // let c = Vector2D(x: Double(coords.x), y: Double(coords.y))
            
            view.viewportOffset = view.viewportOffset - offset
            
            panBegin = float2(x: c.x, y: c.y)

        }
    }
    
    @IBAction func handleChangeElasticity(sender: UISlider) {
        
        if let sim = sim {
            sim.defaultSpringiness = Float(sender.value)
        } else {
            print("No simulator connected")
        }
    }
    
    @IBAction func handleClick(sender: UITapGestureRecognizer) {
        
        if let view = sender.view as? SimulationUIView
        {
            let coords = sender.locationInView( view )
            let c = float2(x: Float(coords.x), y: Float(coords.y))
            
            let v = view.toViewspace(c)
            
            if let sim = sim {
                sim.addBall(Float(v.x), y: Float(v.y))
            }
        }
        
        simulationView.setNeedsDisplay()
        
        print("Clicked!")
    }
    
    @IBAction func handleClearScene(sender: AnyObject) {
        sim?.clear()
        
        simulationView.setNeedsDisplay()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // acceleration stuff
        motionManager = CMMotionManager()
        if motionManager!.deviceMotionAvailable {
            print("Motion device Found!!")
            motionManager?.deviceMotionUpdateInterval = 0.005
            
            motionManager?.startDeviceMotionUpdates()
            
            /*
            manager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue()) {
                [weak self] (data: CMDeviceMotion!, error: NSError!) in
                
                println("Got acceleration update")
                self!.sim?.gravityX = data.gravity.x
                self!.sim?.gravityY = data.gravity.y
            
            }
            */
        } else {
           print("Motion device not available")
        }
        
        sim = Simulation()
        
        simulationView.simulation = sim
        
        timer = NSTimer.scheduledTimerWithTimeInterval(updateInterval, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    func update()
    {
        
        if let deviceMotion = motionManager?.deviceMotion {
            
            sim?.gravity.x = Float(deviceMotion.gravity.x)
            sim?.gravity.y = Float(-deviceMotion.gravity.y)
            
        }
        
        
        currentTime = NSDate.timeIntervalSinceReferenceDate()
        
        let dt = Float(currentTime - startTime)
        
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

