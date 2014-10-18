//
//  GameMaster.swift
//  Swiftris
//
//  Created by Ashley Tam on 2014-10-10.
//  Copyright (c) 2014 Bloc. All rights reserved.
//

let NumColumns = 10
let NumRows = 20

let StartingColumn = 4
let StartingRow = 0

let PreviewColumn = 12
let PreviewRow = 1

protocol GameMasterDelegate {
    func gameDidEnd(gamemaster: GameMaster)
    func gameDidBegin(gamemaster: GameMaster)
    func gameShapeDidLand(gamemaster: GameMaster)
    func gameShapeDidMove(gamemaster: GameMaster)
    func gameShapeDidDrop(gamemaster: GameMaster)
    func gameDidLevelUp(gamemaster: GameMaster)
}

class GameMaster {
    var blockArray:Array2D<Block>
    var nextShape:Shape?
    var fallingShape:Shape?
    //delegate is notified of several events throughout course of game
    //GameViewController will implement and attach itself as delegate in order to update UI and react to game state changes
    var delegate:GameMasterDelegate?
    
    init() {
        fallingShape = nil
        nextShape = nil
        blockArray = Array2D<Block>(columns: NumColumns, rows: NumRows)
    }
    
    func beginGame() {
        if (nextShape == nil) {
            nextShape = Shape.random(PreviewColumn, startingRow: PreviewRow)
        }
        delegate?.gameDidBegin(self)
    }
    
    // asigns nextShape (the preview shape) as fallingShape (the current moving Tetromino)
    // newShape() then creates a new preview shape before moving fallingShape to starting row and column
    func newShape() -> (fallingShape:Shape?, nextShape:Shape?) {
        fallingShape = nextShape
        nextShape = Shape.random(PreviewColumn, startingRow: PreviewRow)
        fallingShape?.moveTo(StartingColumn, row: StartingRow)
        
        // detect the ending of a game --> when new shape located at designated starting location collides with existing blocks
        if detectIllegalPlacement() {
            nextShape = fallingShape
            nextShape!.moveTo(PreviewColumn, row: PreviewRow)
            endGame()
            return (nil, nil)
        }
        return (fallingShape, nextShape)
    }
    
    // checks both block boundary conditions
    // determines whether or not block exceeds legal size of game board or whether or not block's current location overlaps with existing block
    func detectIllegalPlacement() -> Bool {
        if let shape = fallingShape {
            for block in shape.blocks {
                if block.column < 0 || block.column >= NumColumns || block.row < 0 || block.row >= NumRows {
                    return true
                } else if blockArray[block.column, block.row] != nil {
                    return true
                }
            }
        }
        return false
    }
    
    // adds falling shape to collection of blocks
    // once it is part of gameboard, fallingShape is nullified and delegate is notified of new shape entering
    func settleShape() {
        if let shape = fallingShape {
            for block in shape.blocks {
                blockArray[block.column, block.row] = block
            }
            fallingShape = nil
            delegate?.gameShapeDidLand(self)
        }
    }
    
    // detects when one of shapes' bottom blocks is located immediately above a block on game board or when one of those same blocks has reached bottom of game board
    func detectTouch() -> Bool {
        if let shape = fallingShape {
            for bottomBlock in shape.bottomBlocks {
                if bottomBlock.row == NumRows - 1 || blockArray[bottomBlock.column, bottomBlock.row + 1] != nil {
                    return true
                }
            }
        }
        return false
    }
    
    func endGame() {
        delegate?.gameDidEnd(self)
    }
    
    // conveience function provided to drop a shape to bottom of game board
    // continue dropping shape by single row until illegal placement state is reached where it will be raised and notified that drop has occurred
    func dropShape() {
        if let shape = fallingShape {
            while detectIllegalPlacement() == false {
                shape.lowerShapeByOneRow()
            }
            shape.raiseShapeByOneRow()
            delegate?.gameShapeDidDrop(self)
        }
    }
    
    // function called once every tick
    // attempts to lower shape by one row and ends game if it fails to do so
    func letShapeFall() {
        if let shape = fallingShape {
            shape.lowerShapeByOneRow()
            if detectIllegalPlacement() {
                shape.raiseShapeByOneRow()
                if detectIllegalPlacement() {
                    endGame()
                } else {
                    settleShape()
                }
            } else {
                delegate?.gameShapeDidMove(self)
                if detectTouch() {
                    settleShape()
                }
            }
        }
    }
    
    func rotateShape() {
        if let shape = fallingShape {
            shape.rotateClockwise()
            if detectIllegalPlacement() {
                shape.rotateCounterClockwise()
            } else {
                delegate?.gameShapeDidMove(self)
            }
        }
    }
    
    func moveShapeRight() {
        if let shape = fallingShape {
            shape.shiftLeftByOneColumn()
            if detectIllegalPlacement() {
                shape.shiftRightByOneColumn()
                return
            }
            delegate?.gameShapeDidMove(self)
        }
    }
    
    func moveShapeLeft() {
        if let shape = fallingShape {
            shape.shiftRightByOneColumn()
            if detectIllegalPlacement() {
                shape.shiftLeftByOneColumn()
                return
            }
            delegate?.gameShapeDidMove(self)
        }
    }
}
