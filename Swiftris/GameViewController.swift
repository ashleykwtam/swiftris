//
//  GameViewController.swift
//  Swiftris
//
//  Created by Ashley Tam on 2014-10-06.
//  Copyright (c) 2014 Bloc. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
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
        gameMaster.beginGame()
        
        // Present the scene.
        skView.presentScene(scene)

        scene.addPreviewShapeToScene(gameMaster.nextShape!) {
            self.gameMaster.nextShape?.moveTo(StartingColumn, row: StartingRow)
            self.scene.movePreviewShape(self.gameMaster.nextShape!) {
                let nextShapes = self.gameMaster.newShape()
                self.scene.startTicking()
                self.scene.addPreviewShapeToScene(nextShapes.nextShape!) {}
            }
        }
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func didTick() {
        gameMaster.fallingShape?.lowerShapeByOneRow()
        scene.redrawShape(gameMaster.fallingShape!, completion: {})
    }
}
