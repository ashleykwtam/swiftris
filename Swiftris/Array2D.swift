//
//  Array2D.swift
//  Swiftris
//
//  Created by Ashley Tam on 2014-10-06.
//  Copyright (c) 2014 Bloc. All rights reserved.
//

// class Array2D is defined
// generic arrays actually of type struct, but class is needed since class objs passed by reference while structures passed by value (copied)
// parameter <T> allows array to store any type of data
class Array2D<T>{
    let columns: Int
    let rows: Int
    
    // array declared, ? symbolizes optional value (can be nil)
    var array: Array<T?>
    
    // internal array structure instantiated with size of rows * columns
    // Array2D can store as many objs as game board requires
    init(columns: Int, rows: Int){
        self.columns = columns
        self.rows = rows
        
        array = Array<T?>(count: rows * columns, repeatedValue: nil)
    }
    
    // customer subscript capable of supporting array[column, row]
    subscript(column: Int, row: Int) -> T? {
        
        // gets value at given location
        get {
            return array[(row * columns) + column]
        }
        
        // reverse of getter, newValue assigned 
        set(newValue) {
            array[(row * columns) + column] = newValue
        }
    }
}
