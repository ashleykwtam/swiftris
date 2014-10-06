//
//  GameScene.swift
//  Swiftris
//
//  Created by Ashley Tam on 2014-10-06.
//  Copyright (c) 2014 Bloc. All rights reserved.
//

import SpriteKit

// represents the slowest speed at which shapes will travel
let TickLengthLevelOne = NSTimeInterval(600)

class GameScene: SKScene {
    
    // tickLengthMillis set to TickLengthLevelOne by default
    // lastTick will track last time a tick is experienced
    // tick:(() -> ()) is a closure; block of code that performs a function; takes no params and returns nothing, it is optional and may be nil
    var tick:(() -> ())?
    var tickLengthMillis = TickLengthLevelOne
    var lastTick:NSDate?
    
    required init(coder aDecoder: NSCoder!){
        fatalError("NSCoder not supported")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        anchorPoint = CGPoint(x: 0, y: 1.0)
        
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 0, y: 0)
        background.anchorPoint = CGPoint(x: 0, y: 1.0)
        addChild(background)
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        // if lastTick is missing, we are paused
        if lastTick == nil {
            return
        }
        // if lastTick present, recover time passed since last execution of update by invoking function timeIntervalSinceNow
        // ! bc the object is optional --> before referencing it, we must de-reference the optional by !
        var timePassed = lastTick!.timeIntervalSinceNow * -1000.0
        // check if time passed has exceeded tickLengthMillis; if enough time elapsed, report a tick
        // tick?() is shorthand for if tick != nil { tick!() }
        if timePassed > tickLengthMillis {
            lastTick = NSDate.date()
            tick?()
        }
    }
    
    // accessor methods to let external classes stop and start ticking process
    func startTicking() {
        lastTick = NSDate.date()
    }
    
    func stopTicking(){
        lastTick = nil
    }
}
