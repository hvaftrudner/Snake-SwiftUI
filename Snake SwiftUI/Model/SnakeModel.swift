//
//  SnakeModel.swift
//  Snake SwiftUI
//
//  Created by Kristoffer Eriksson on 2021-06-04.
//

import Foundation
import SwiftUI

struct Snake {
    var origin: BlockLocation
    var snakeBlocks: [BlockLocation]
    
    
    static func createSnake(numRows: Int, numCols: Int) -> Snake {
        
        //Start in the middle, head of snake
        let origin = BlockLocation(row: (numRows + 1) / 2  , col: numCols / 2)
        
        return Snake(origin: origin, snakeBlocks: [origin])
    }
    
    func moveBy(row: Int, col: Int) -> Snake {
        
        let newSnakeBlocks = changeSnake(snakeArray: self.snakeBlocks)
        let newOrigin = BlockLocation(row: origin.row + row, col: origin.col + col)
        
        print(newSnakeBlocks.count)
        return Snake(origin: newOrigin, snakeBlocks: newSnakeBlocks)
    }
    
    func changeSnake(snakeArray: [BlockLocation]) -> [BlockLocation] {
        
        var newArray = [BlockLocation]()
        
        for block in 0..<snakeBlocks.count {
             
            if block > 1 {
                //works
                let location = snakeArray[block - 1]
                let new = BlockLocation(row: location.row, col: location.col)
                newArray.append(new)
            } else {
                //Works but then stacks all other foods on same space
                //print(snakeBlocks[block])
                let newBlock = BlockLocation(row: origin.row, col: origin.col)
                newArray.append(newBlock)
            }
         }
        
        return newArray
    }
}

struct Food {
    var origin: BlockLocation
    
    static func generateFood(numRows: Int, numCols: Int) -> Food {
        let randomX = Int.random(in: 0..<10)
        let randomY = Int.random(in: 0..<23)
        
        let newOrigin = BlockLocation(row: randomY, col: randomX)
        
        //check to not spawn outside map or on snake
        
        return Food(origin: newOrigin)
    }
}

struct BlockLocation {
    var row: Int
    var col: Int
}
