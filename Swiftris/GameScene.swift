//
//  GameScene.swift
//  Swiftris
//
//  Created by Ashley Tam on 2014-10-06.
//  Copyright (c) 2014 Bloc. All rights reserved.
//

import SpriteKit

// define point size of each block sprite: 20.0 x 20.0
let BlockSize:CGFloat = 20.0

// represents the slowest speed at which shapes will travel
let TickLengthLevelOne = NSTimeInterval(600)

class GameScene: SKScene {
    
    // SKNodes -> superimposed layers of activity within scene
    // gameLayer sits above background visuals and shapeLayer on top of that
    let gameLayer = SKNode()
    let shapeLayer = SKNode()
    let LayerPosition = CGPoint(x: 6, y: -6)
    
    // tickLengthMillis set to TickLengthLevelOne by default
    // lastTick will track last time a tick is experienced
    // tick:(() -> ()) is a closure; block of code that performs a function; takes no params and returns nothing, it is optional and may be nil
    var tick:(() -> ())?
    var tickLengthMillis = TickLengthLevelOne
    var lastTick:NSDate?
    
    var textureCache = Dictionary<String, SKTexture>()
    
    required init(coder aDecoder: NSCoder){
        fatalError("NSCoder not supported")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        anchorPoint = CGPoint(x: 0, y: 1.0)
        
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 0, y: 0)
        background.anchorPoint = CGPoint(x: 0, y: 1.0)
        addChild(background)
        
        addChild(gameLayer)
        
        let gameBoardTexture = SKTexture(imageNamed: "background")
        let gameBoard = SKSpriteNode(texture: gameBoardTexture, size: CGSizeMake(BlockSize * CGFloat(NumColumns), BlockSize * CGFloat(NumRows)))
        gameBoard.anchorPoint = CGPoint(x: 0, y: 1.0)
        gameBoard.position = LayerPosition
        
        shapeLayer.position = LayerPosition
        shapeLayer.addChild(gameBoard)
        gameBoard.addChild(shapeLayer)
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
    
    // function returns precise coordinate on screen for where a block sprite belongs based on row and column position
    // need to find its center coordinate before placing it in shapeLayer object
    func pointForColumn(column: Int, row: Int) -> CGPoint {
        let x: CGFloat = LayerPosition.x + (CGFloat(column) * BlockSize) + (BlockSize / 2)
        let y: CGFloat = LayerPosition.y - (CGFloat(row) * BlockSize) + (BlockSize / 2)
        return CGPointMake(x, y)
    }
    
    
    func addPreviewShapeToScene(shape:Shape, completion:() -> ()) {
        for (idx, block) in enumerate(shape.blocks) {
            
            // create method that will add a shape to the scene as a preview shape
            // dictionary used to store copies of reusable SKTexture objects
            var texture = textureCache[block.spriteName]
            if texture == nil {
                texture = SKTexture(imageNamed: block.spriteName)
                textureCache[block.spriteName] = texture
            }
            let sprite = SKSpriteNode(texture: texture)
            
            // use pointForColumn method to place each block's sprite in proper location
            // start it at row - 2, such that preview piece animates smoothly into place
            sprite.position = pointForColumn(block.column, row: block.row - 2)
            shapeLayer.addChild(sprite)
            block.sprite = sprite
            
            sprite.alpha = 0
            
            // introduce SKAction objects which are responsible for visually manipulating SKNode objects
            // each block fades and moves into place as it appears as part of the next piece
            // move two rows down and fade to 70% opacity
            let moveAction = SKAction.moveTo(pointForColumn(block.column, row: block.row), duration: NSTimeInterval(0.2))
            moveAction.timingMode = .EaseOut
            let fadeInAction = SKAction.fadeAlphaTo(0.7, duration: 0.4)
            fadeInAction.timingMode = .EaseOut
            sprite.runAction(SKAction.group([moveAction, fadeInAction]))
        }
        runAction(SKAction.waitForDuration(0.4), completion: completion)
    }
    
    // movePreviewShape and redrawShape makes use of SKAction objects to move and redraw given shape
    
    func movePreviewShape(shape:Shape, completion:() -> ()) {
        for (idx, block) in enumerate(shape.blocks) {
            let sprite = block.sprite!
            let moveTo = pointForColumn(block.column, row:block.row)
            let moveToAction:SKAction = SKAction.moveTo(moveTo, duration: 0.2)
            moveToAction.timingMode = .EaseOut
            sprite.runAction(SKAction.group([moveToAction, SKAction.fadeAlphaTo(1.0, duration: 0.2)]), completion: nil)
        }
        runAction(SKAction.waitForDuration(0.2), completion: completion)
    }
    
    func redrawShape(shape:Shape, completion:() -> ()) {
        for (idx, block) in enumerate(shape.blocks) {
            let sprite = block.sprite!
            let moveTo = pointForColumn(block.column, row:block.row)
            let moveToAction:SKAction = SKAction.moveTo(moveTo, duration: 0.05)
            moveToAction.timingMode = .EaseOut
            sprite.runAction(moveToAction, completion: nil)
        }
        runAction(SKAction.waitForDuration(0.05), completion: completion)
    }
}
