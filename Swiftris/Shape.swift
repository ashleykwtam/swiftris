//
//  Shape.swift
//  Swiftris
//
//  Created by Ashley Tam on 2014-10-06.
//  Copyright (c) 2014 Bloc. All rights reserved.
//

import SpriteKit

let NumOrientations: UInt32 = 4

// created enum helper to define shape's orientation
// Tetris piece can face 1 of 4 directions: 0, 90, 180, 270
enum Orientation: Int, Printable {
    
    case Zero = 0, Ninety, OneEighty, TwoSeventy
    
    var description: String {
        switch self {
        case .Zero:
            return "0"
        case .Ninety:
            return "90"
        case .OneEighty:
            return "180"
        case .TwoSeventy:
            return "270"
        }
    }
    
    static func random() -> Orientation {
        return Orientation.fromRaw(Int(arc4random_uniform(NumOrientations)))!
    }
    
    // method capable of returning next orientation when traveling either clockwise or counterclockwise
    static func rotate(orientation:Orientation, clockwise: Bool) -> Orientation {
        var rotated = orientation.toRaw() + (clockwise ? 1 : -1)
        if rotated > Orientation.TwoSeventy.toRaw() {
            rotated = Orientation.Zero.toRaw()
        } else if rotated < 0 {
            rotated = Orientation.TwoSeventy.toRaw()
        }
        return Orientation.fromRaw(rotated)!
    }
}

// # of total shape varieties: 7 diff tetris pieces
let NumShapeTypes: UInt32 = 7

// shape indexes
let FirstBlockIdx: Int = 0
let SecondBlockIdx: Int = 1
let ThirdBlockIdx: Int = 2
let FourthBlockIdx: Int = 3

class Shape: Hashable, Printable {
    
    let color:BlockColor
    
    // blocks comprising shape
    var blocks = Array<Block>()
    
    // current orientation of shape
    var orientation: Orientation
    
    // column and row representing shape's anchor point
    var column, row:Int
    
    // required overrides
    // blockRowColumnPositions defines a computed Dictionary; dictionary has square braces and maps one type of object to another [key, value]
    // subscripts are now keys --> orientation objects
    // Array<()> is a tuple (Swift array) which passes and returns multiple variables without defining a custom struct
    // blockRowColumnPositions and bottomBlocksForORientations return empty values, meant for subclasses to provide meaningful data later
    var blockRowColumnPositions: [Orientation: Array<(columnDiff: Int, rowDiff: Int)>] {
        return [:]
    }
    
    var bottomBlocksForOrientations: [Orientation: Array<Block>] {
        return [:]
    }
    
    // complete computed property designed to return bottom blocks of the shape at its curent orientation
    var bottomBlocks:Array<Block> {
        if let bottomBlocks = bottomBlocksForOrientations[orientation] {
            return bottomBlocks
        }
        return []
    }
    
    // iterate through entire blocks array
    var hashValue:Int {
        return reduce(blocks, 0) { $0.hashValue ^ $1.hashValue }
    }
    
    var description:String {
        return "\(color) block facing \(orientation): \(blocks[FirstBlockIdx]), \(blocks[SecondBlockIdx]), \(blocks[ThirdBlockIdx]), \(blocks[FourthBlockIdx])"
    }
    
    init(column:Int, row:Int, color:BlockColor, orientation:Orientation) {
        self.color = color
        self.column = column
        self.row = row
        self.orientation = orientation
        initializeBlocks()
    }
    
    // conveience initializer calls down to a standard initializer
    // simplifies the intialization process for users of Shape class
    convenience init(column:Int, row:Int) {
        self.init(column:column, row:row, color:BlockColor.random(), orientation:Orientation.random())
    }
    
    // final function means it cannot be overridden by subclasses
    final func initializeBlocks() {
        // if conditional first attempts to assign array into blockRowColumnTranslations after extracting it from computed dictionary property
        if let blockRowColumnTranslations = blockRowColumnPositions[orientation] {
            for i in 0..<blockRowColumnTranslations.count {
                let blockRow = row + blockRowColumnTranslations[i].rowDiff
                let blockColumn = column + blockRowColumnTranslations[i].columnDiff
                let newBlock = Block(column: blockColumn, row: blockRow, color:color)
                blocks.append(newBlock)
            }
        }
    }
}

func == (lhs: Shape, rhs: Shape) -> Bool {
    return lhs.row == rhs.row && lhs.column == rhs.column
}
