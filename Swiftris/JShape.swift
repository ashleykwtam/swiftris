//
//  JShape.swift
//  Swiftris
//
//  Created by Ashley Tam on 2014-10-10.
//  Copyright (c) 2014 Bloc. All rights reserved.
//

class JShape:Shape {
    /*
        ** pivots with '1'
    
        Orientations 0
            | 0 |
            | 1 |
        | 3 | 2 |
    
        Orientations 90
        | 3 |
        | 2 | 1 | 0 |
        
        Orientations 180
        | 2 | 3 |
        | 1 |
        | 0 |
    
        Orientaitons 270
        | 0 | 1 | 2 |
                | 3 |
    */
    override var blockRowColumnPositions: [Orientation: Array<(columnDiff: Int, rowDiff: Int)>] {
        return [
            Orientation.Zero:       [(1, 0), (1, 1), (1, 2), (0, 2)],
            Orientation.Ninety:     [(2, 1), (1, 1), (0, 1), (0, 0)],
            Orientation.OneEighty:  [(0, 2), (0, 1), (0, 0), (1, 0)],
            Orientation.TwoSeventy: [(0, 0), (1, 0), (2, 0), (2, 1)]
        ]
    }
    
    override var bottomBlocksForOrientations: [Orientation: Array<Block>] {
        return [
            Orientation.Zero:       [blocks[ThirdBlockIdx], blocks[FourthBlockIdx]],
            Orientation.Ninety:     [blocks[FirstBlockIdx], blocks[SecondBlockIdx], blocks[ThirdBlockIdx]],
            Orientation.OneEighty:  [blocks[FirstBlockIdx], blocks[FourthBlockIdx]],
            Orientation.TwoSeventy: [blocks[FirstBlockIdx], blocks[SecondBlockIdx], blocks[FourthBlockIdx]]
        ]
    }
}
