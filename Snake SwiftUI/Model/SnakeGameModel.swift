//
//  SnakeGameModel.swift
//  Snake SwiftUI
//
//  Created by Kristoffer Eriksson on 2021-06-04.
//

import Foundation
import SwiftUI

enum Direction: CaseIterable {
    case up, down, left, right
}

class SnakeGameModel: ObservableObject {
    var numRows: Int
    var numCols: Int
    @Published var gameBoard: [[SnakeGameBlock?]]
    @Published var snake : Snake?
    
    @Published var food: Food?
    
    //Add timer
    var timer: Timer?
    //Add gamespeed
    var gameSpeed: Double
    //Add movement var
    var direction: Direction = .down
    
    //iNit gameboard with right amount of squares
    init(numRows: Int = 23, numCols: Int = 10){
        self.numRows = numRows
        self.numCols = numCols
        
        gameBoard = Array(repeating: Array(repeating: nil, count: numRows), count: numCols)
        gameSpeed = 0.2
        resumeGame()
    }
    
    func blockClicked(col: Int, row: Int){
        print("Row: \(row), Col: \(col)")

        if gameBoard[col][row] == nil {
            gameBoard[col][row] = SnakeGameBlock(color: Color.green)
        }
    }
    
    //Resume
    func resumeGame(){
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: gameSpeed, repeats: true, block: runEngine)
    }
    
    //Pause
    func pauseGame(){
        timer?.invalidate()
    }
    
    //Add engine
    func runEngine(timer: Timer){
        //Check if we just ate a food / Spawn a new food if thats the case
        
        //SPawn a snake if we can
        guard snake != nil && food != nil else {
            print("Starting game, spawning snake")
            snake = Snake.createSnake(numRows: numRows, numCols: numCols)
            if !isValidPosition(testSnake: snake!){
                pauseGame()
                print("Game Over")
            }
            
            food = Food.generateFood(numRows: numRows, numCols: numCols)
            if !isValidFoodPosition(testFood: food!, testSnake: snake!){
                pauseGame()
                food = nil
                print("not valid food position")
            }
            return
        }
        //Move Snake
        //FIX , add enum to choose which way to move
        switch direction {
        case .down:
            if moveSnakeDown() {
                print("moving snake down")
                return
            }
        case .up:
            if moveSnakeUp() {
                print("moving snake up")
                return
            }
        case .left:
            if moveSnakeLeft(){
                print("moving snake left")
                return
            }
        case .right:
            if moveSnakeRight() {
                print("moving snake right")
                return
            }
        }
        
        
        //placeSnakeOnBoard()
    }
    //Movement
    func moveSnake(colOffset: Int, rowOffset: Int) -> Bool {
        guard let currentSnake = snake else {return false}
        guard let currentFood = food else {return false}
        
        var newSnake = currentSnake.moveBy(row: rowOffset, col: colOffset)
        if isValidPosition(testSnake: newSnake){
            
            if newSnake.origin.row == currentFood.origin.row && newSnake.origin.col == currentFood.origin.col {
                
                //newSnake.snakeBlocks.append(BlockLocation(row: newSnake.origin.row, col: newSnake.origin.col))
                newSnake.snakeBlocks.append(BlockLocation(row: currentFood.origin.row, col: currentFood.origin.col))
                
                food = nil
                food = Food.generateFood(numRows: numRows, numCols: numCols)
            
            }
            
            snake = newSnake
            
            print("moved")
            return true
            
        }
        print("couldnt move")
        return false
        
    }
    
    func moveSnakeDown() -> Bool{
        return moveSnake(colOffset: 0, rowOffset: -1)
    }
    
    func moveSnakeUp() -> Bool{
        return moveSnake(colOffset: 0, rowOffset: 1)
    }
    
    func moveSnakeLeft() -> Bool {
        return moveSnake(colOffset: -1, rowOffset: 0)
    }
    
    func moveSnakeRight() -> Bool {
        return moveSnake(colOffset: 1, rowOffset: 0)
    }
    
    //Validation
    
    //Change isValidPosition to take <Generic>T
    func isValidPosition(testSnake: Snake) -> Bool {
        
        //used when array is filled - snake is longer
        for block in testSnake.snakeBlocks {
            let row = testSnake.origin.row // + block.row
            if row < 0 || row >= numRows {
                print("rowError")
                return false
                
            }
            
            let col = testSnake.origin.col // + block.col
            if col < 0 || col >= numCols {
                print("ColError")
                return false
            }
            
            if gameBoard[col][row] != nil {
                print("NilError")
                return false
            }
        }
        
        
        return true
    }
    
    func isValidFoodPosition(testFood: Food, testSnake: Snake) -> Bool {
        
       
            let row = testFood.origin.row // + block.row
            if row < 0 || row >= numRows {
                print("rowError")
                return false
                
            }
            
            let col = testFood.origin.col // + block.col
            if col < 0 || col >= numCols {
                print("ColError")
                return false
            }
            
            if gameBoard[col][row] != nil {
                print("NilError")
                return false
            }
        
            for block in testSnake.snakeBlocks {
                if block.col == testFood.origin.col && block.row == testFood.origin.row {
                    return false
                }
            }

        
        return true
    }
    
    //can be used with food for snake ( change it to accomodate a new food model)
    func placeSnakeOnBoard(){
        guard let currentSnake = snake else {return}
        
        for block in currentSnake.snakeBlocks {
            let row = currentSnake.origin.row + block.row
            if row < 0 || row >= numRows {
                continue
            }
            
            let col = currentSnake.origin.col + block.col
            if col < 0 || col >= numCols {
                continue
            }
            
            gameBoard[col][row] = SnakeGameBlock(color: Color.blue)
        }
    }
}

struct SnakeGameBlock {
    var color: Color
}
