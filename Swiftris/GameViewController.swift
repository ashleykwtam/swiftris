//
//  GameViewController.swift
//  Swiftris
//
//  Created by Ashley Tam on 2014-10-06.
//  Copyright (c) 2014 Bloc. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController, GameMasterDelegate {
    
    var scene: GameScene!
    var gameMaster: GameMaster!
    
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
    
    func gameShapeDidDrop(gamemaster: GameMaster) {
        
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
