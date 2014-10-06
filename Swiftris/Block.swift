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
