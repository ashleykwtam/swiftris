//
//  Block.swift
//  Swiftris
//
//  Created by Ashley Tam on 2014-10-06.
//  Copyright (c) 2014 Bloc. All rights reserved.
//

import SpriteKit

// defined precisely how many colors are avialable in Swift
let NumberOfColors: UInt32 = 6

// declare enumeration; of type Int and implements the Printable protocol
// classes, structures, enums which implement Printable are capable of generating human-readable strings when debugging/print value to console
enum BlockColor: Int, Printable {
    
    // provide full list of options, one for each color 0-5
    case Blue = 0, Orange, Purple, Red, Teal, Yellow
    
    // computed property spriteName is defined: property that behaves like a typical variable but when accessing it, code block is invoked to generate a value each time
    // spriteName returns correct filename for given color through a switch...case statement
    var spriteName: String {
        switch self {
        case .Blue:
            return "blue"
        case .Orange:
            return "orange"
        case .Purple:
            return "purple"
        case .Red:
            return "red"
        case .Teal:
            return "teal"
        case .Yellow:
            return "yellow"
        }
    }
    
    // another computed property; required if we are to adhere to Printable protocol; returns spriteName of the color
    var description: String {
        return self.spriteName
    }
    
    
    // static function returns random choice among colors found in BlockColor
    // uses enum function fromRaw(Int) to recover enum which matches numerical value passed into it
    static func random() -> BlockColor {
        return BlockColor.fromRaw(Int(arc4random_uniform(NumberOfColors)))!
    }
}

// Block is declared a class which implements both protocols
// Hashable allows Block to be stored in Array2D
class Block: Hashable, Printable {
    
    // let means no longer can be re-assigned
    let color: BlockColor
    
    // properties represent location of Block on our game board
    // SKSpriteNode represents visual element of Block to be used by GameScene when rendering each Block
    var column: Int
    var row: Int
    var sprite: SKSpriteNode?
    
    // shortcut for recovering file name of sprite used when displaying Block
    var spriteName: String {
        return color.spriteName
    }
    
    // return exclusive-or of row and column properties to generate a unique integer for each Block
    var hashValue: Int {
        return self.column ^ self.row
    }
    
    // description implemented to comply with Printable protocal
    // printing a Block will result in e.g. "blue: [8,3]"
    var description: String {
        return "\(color): [\(column), \(row)]"
    }
    
    init(column:Int, row:Int, color:BlockColor) {
        self.column = column
        self.row = row
        self.color = color
    }
    
    // customer operator to compare one Block with another
    // returns true iif Blocks are in same location and of same color
    // required to support Hashable protocol
    func == (lhs: Block, rhs: Block) -> Bool {
        return lhs.column == rhs.column && lhs.row == rhs.row && lhs.color.toRaw() == rhs.color.toRaw()
    }
}
