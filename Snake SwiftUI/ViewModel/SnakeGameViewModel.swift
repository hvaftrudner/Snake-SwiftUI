//
//  SnakeGameViewModel.swift
//  Snake SwiftUI
//
//  Created by Kristoffer Eriksson on 2021-06-04.
//

import SwiftUI
import Combine

class SnakeGameViewModel: ObservableObject {
    
    @Published var snakeGameModel = SnakeGameModel()
    
    var numRows: Int {snakeGameModel.numRows}
    var numCols: Int {snakeGameModel.numCols}
    
    var gameBoard : [[SnakeGameSquare]] {
        var board = snakeGameModel.gameBoard.map {$0.map(convertToSquare)}
        
        if let snake = snakeGameModel.snake {
            //check here, change origin of all blocks
            board[snake.origin.col][snake.origin.row] = SnakeGameSquare(color: Color.black)
            for blockLocation in snake.snakeBlocks {
                board[blockLocation.col][blockLocation.row] = SnakeGameSquare(color: Color.blue)
            }
        }
        
        if let food = snakeGameModel.food {
            
            board[food.origin.col][food.origin.row] = SnakeGameSquare(color: Color.yellow)
        }
        
        return board
    }
    
    var anyCancellable: AnyCancellable?
    var lastMoveLocation: CGPoint?
    
    init(){
        anyCancellable = snakeGameModel.objectWillChange.sink{
            self.objectWillChange.send()
        }
    }
    
    func convertToSquare(block: SnakeGameBlock?) -> SnakeGameSquare {
        return SnakeGameSquare(color: Color.red)
    }
    
    //touch controlls
    
    func getMoveGesture() -> some Gesture {
        return DragGesture()
            .onChanged(onMoveChanged(value:))
            .onEnded(onMoveEnded(_:))
    }
    
    func onMoveChanged(value: DragGesture.Value){
        guard let start = lastMoveLocation else {
            lastMoveLocation = value.location
            return
        }
        
        let xDiff = value.location.x - start.x
        if xDiff > 10 {
            print("moving right")
            //let _ = snakeGameModel.moveSnakeRight() // maybe remove this
            lastMoveLocation = value.location
            snakeGameModel.direction = .right
            return
        }
        if xDiff < -10 {
            print("moving left")
            //let _ = snakeGameModel.moveSnakeLeft()
            lastMoveLocation = value.location
            snakeGameModel.direction = .left
            return
        }
        
        let yDiff = value.location.y - start.y
        if yDiff > 10 {
            print("moving down")
            //let _ = snakeGameModel.moveSnakeDown()
            lastMoveLocation = value.location
            snakeGameModel.direction = .down
            return
        }
        if yDiff < -10 {
            print("moving up")
            //let _ = snakeGameModel.moveSnakeUp()
            lastMoveLocation = value.location
            snakeGameModel.direction = .up
            return
        }
    }
    
    func onMoveEnded(_: DragGesture.Value){
        lastMoveLocation = nil
    }
}

struct SnakeGameSquare {
    var color: Color
}
