//
//  ViewController.swift
//  DrawingSimulation
//
//  Created by Robert Dickerson on 7/4/15.
//  Copyright (c) 2015 Robert Dickerson. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {

    @IBOutlet weak var simulationView: SimulationUIView!
    
    var sim : Simulation?
    var startTime = NSDate.timeIntervalSinceReferenceDate()
    var currentTime: NSTimeInterval = 0
    var timer : NSTimer?
    var motionManager : CMMotionManager?
    var panBegin : Vector2D?

    override func shouldAutorotate() -> Bool {
        return false
    }
    
    @IBAction func handleSimRun(switchState: UISwitch) {
        if switchState.on {
            timer = NSTimer.scheduledTimerWithTimeInterval(0.005, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
        } else {
            timer?.invalidate()
        }
    }
    
    @IBAction func changeGravity(sender: UISlider) {
        sim?.gravityAcceleration = Double(sender.value)
    }
    
    @IBAction func handleChangeMass(sender: UISlider) {
        sim?.defaultMass = Double(sender.value)
    }
    
    @IBAction func handlePan(sender: UIPanGestureRecognizer) {
        if let view = sender.view as? SimulationUIView
        {
            let coords = sender.translationInView(view)
            let c = Vector2D(x: Double(coords.x), y: Double(coords.y))
            
            
            if sender.state == UIGestureRecognizerState.Began
            {
               panBegin = c
            }
            
            let offset = c - panBegin!
            
            // println(coords)
            
            // let c = Vector2D(x: Double(coords.x), y: Double(coords.y))
            
            view.viewportOffset = view.viewportOffset - offset
            
            panBegin = Vector2D(x: c.x, y: c.y)

        }
    }
    
    @IBAction func handleChangleElasticity(sender: UISlider) {
        
        sim?.defaultSpringiness = Double(sender.value)
    }
    
    @IBAction func handleClick(sender: UITapGestureRecognizer) {
        
        if let view = sender.view as? SimulationUIView
        {
            let coords = sender.locationInView( view )
            let c = Vector2D(x:Double(coords.x), y: Double(coords.y))
            
            let v = view.toViewspace(c)
            
            sim?.addBall(Double(v.x), y: Double(v.y))
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
        
        timer = NSTimer.scheduledTimerWithTimeInterval(0.005, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    func update()
    {
        
        if let deviceMotion = motionManager?.deviceMotion {
            
            sim?.gravity.x = Double(deviceMotion.gravity.x)
            sim?.gravity.y = Double(-deviceMotion.gravity.y)
            
        }
        
        
        currentTime = NSDate.timeIntervalSinceReferenceDate()
        
        let dt = currentTime - startTime
        
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

