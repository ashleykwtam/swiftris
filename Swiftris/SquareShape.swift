//
//  SquareShape.swift
//  Swiftris
//
//  Created by Ashley Tam on 2014-10-10.
//  Copyright (c) 2014 Bloc. All rights reserved.
//

// subclasses: provide the distance of each block from the shape's row and column location with respect to each possible orientation

class SquareShape:Shape {
    /*
        | 0 | 1 |
        | 2 | 3 |
        marks the row/column for square
    */
    
    // override blockRowColumnPositions to provide full dictionary of tuple arrays
    // each index represents 1 of 4 blocks; top-left block (block 0) is exactly identical to row and column location --> tuple (0, 0) has 0 column difference and 0 row difference
    override var blockRowColumnPositions: [Orientation: Array<(columnDiff: Int, rowDiff: Int)>] {
        return [
            Orientation.Zero:       [(0, 0), (1, 0), (0, 1), (1, 1)],
            Orientation.OneEighty:  [(0, 0), (1, 0), (0, 1), (1, 1)],
            Orientation.Ninety:     [(0, 0), (1, 0), (0, 1), (1, 1)],
            Orientation.TwoSeventy: [(0, 0), (1, 0), (0, 1), (1, 1)]
        ]
    }
    
    // override by providing dictionary of bottom block arrays
    // square does not rotate so bottom blocks are consistently the third and fourth blocks
    override var bottomBlocksForOrientations: [Orientation: Array<Block>] {
        return [
            Orientation.Zero:       [blocks[ThirdBlockIdx], blocks[FourthBlockIdx]],
            Orientation.OneEighty:  [blocks[ThirdBlockIdx], blocks[FourthBlockIdx]],
            Orientation.Ninety:     [blocks[ThirdBlockIdx], blocks[FourthBlockIdx]],
            Orientation.TwoSeventy: [blocks[ThirdBlockIdx], blocks[FourthBlockIdx]]
        ]
    }
}
