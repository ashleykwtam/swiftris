//
//  GameViewController.swift
//  Swiftris
//
//  Created by Ashley Tam on 2014-10-06.
//  Copyright (c) 2014 Bloc. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController, GameMasterDelegate, UIGestureRecognizerDelegate {
    
    var scene: GameScene!
    var gameMaster: GameMaster!
    
    // keep track of last point on screen at which shape mvmt occurred/where pan begins
    var panPointReference:CGPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the view.
        let skView = view as SKView
        skView.multipleTouchEnabled = false
        
        // Create and configure the scene.
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .AspectFill
        
        scene.tick = didTick
        
        gameMaster = GameMaster()
        gameMaster.delegate = self
        gameMaster.beginGame()
        
        // Present the scene.
        skView.presentScene(scene)

    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    

    @IBAction func didTap(sender: UITapGestureRecognizer) {
        gameMaster.rotateShape()
    }
    
    // pan detection logic: every time finger moves more than 90% of BlockSize points across screen, we move falling shape in corresponding direction of pan
    @IBAction func didPan(sender: UIPanGestureRecognizer) {
        // recover point which defines translation of gesture relative to where it began
        // not absolute coordinate, just measure of distaince that user's finger has travelled
        let currentPoint = sender.translationInView(self.view)
        if let originalPoint = panPointReference {
            // check whether or not x translation has crossed threshold of 90%
            if abs(currentPoint.x - originalPoint.x) > (BlockSize * 0.9) {
                // if threshold is crossed, check velocity of gesture
                // velocity gives direction --> +ve moves right, -ve moves to left
                // move to correct direction and reset reference point
                if sender.velocityInView(self.view).x > CGFloat(0) {
                    gameMaster.moveShapeRight()
                    panPointReference = currentPoint
                } else {
                    gameMaster.moveShapeLeft()
                    panPointReference = currentPoint
                }
            }
        } else if sender.state == .Began {
            panPointReference = currentPoint
        }
    }
    
    @IBAction func didSwipe(sender: UISwipeGestureRecognizer) {
        gameMaster.dropShape()
    }
    
    // implement optional delegate method which allows each gesture recognizer to work in tandem with others
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer!, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer!) -> Bool {
        return true
    }
    
    // when two gestures occur simultaneously, delegate method performs several optional cast conditionals
    // lets pan gesture recognizer take precedence over swipe gesture and tap to do likewise over pan
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer!, shouldBeRequiredToFailByGestureRecognizer otherGestureRecognizer: UIGestureRecognizer!) -> Bool {
        if let swipeRec = otherGestureRecognizer as? UISwipeGestureRecognizer {
            if let panRec = otherGestureRecognizer as? UIPanGestureRecognizer {
                return true
            }
        } else if let panRec = gestureRecognizer as? UIPanGestureRecognizer {
            if let tapRec = otherGestureRecognizer as? UITapGestureRecognizer {
                return true
            }
        }
        return false
    }
    
    func didTick() {
        // substitute previous efforts with new function
        gameMaster.letShapeFall()
    }
    
    func nextShape() {
        let newShapes = gameMaster.newShape()
        if let fallingShape = newShapes.fallingShape {
            self.scene.addPreviewShapeToScene(newShapes.nextShape!) {}
            self.scene.movePreviewShape(fallingShape) {
                self.view.userInteractionEnabled = true
                self.scene.startTicking()
            }
        }
    }
    
    // boolean that allows us to shut down interaction with view
    func gameDidBegin(gamemaster: GameMaster) {
        // following is false when restarting a new game
        if gameMaster.nextShape != nil && gameMaster.nextShape!.blocks[0].sprite == nil {
            scene.addPreviewShapeToScene(gameMaster.nextShape!) {
                self.nextShape()
            }
        } else {
            nextShape()
        }
    }
    
    func gameDidEnd(gamemaster: GameMaster) {
        view.userInteractionEnabled = false
        scene.stopTicking()
    }
    
    func gameDidLevelUp(gamemaster: GameMaster) {
        
    }
    
    // stop ticks, redraw shape at new location and let it drop
    func gameShapeDidDrop(gamemaster: GameMaster) {
        scene.stopTicking()
        scene.redrawShape(gameMaster.fallingShape!) {
            self.gameMaster.letShapeFall()
        }
    }
    
    func gameShapeDidLand(gamemaster: GameMaster) {
        scene.stopTicking()
        nextShape()
    }
    
    // after shape has moved, redraw its rperesentative sprites at new locations
    func gameShapeDidMove(gamemaster: GameMaster) {
        scene.redrawShape(gameMaster.fallingShape!) {}
    }
}
