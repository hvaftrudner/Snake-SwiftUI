//
//  SnakeGameView.swift
//  Snake SwiftUI
//
//  Created by Kristoffer Eriksson on 2021-06-04.
//

import SwiftUI

struct SnakeGameView: View {
    
    //old usage is observedObject
    @StateObject var snakeGame = SnakeGameViewModel()
    
    var body: some View {
        GeometryReader { geo in
            self.drawBoard(boundingRect: geo.size)
        }
        .gesture(snakeGame.getMoveGesture())
        
    }
    
    func drawBoard(boundingRect: CGSize) -> some View {
        let rows = self.snakeGame.numRows
        let cols = self.snakeGame.numCols
        
        //Making block the right size in geo reader
        let blockSize = min(boundingRect.width / CGFloat(cols), boundingRect.height / CGFloat(rows))
        
        //Offsets around board
        let xOffset = (boundingRect.width - blockSize * CGFloat(cols)) / 2
        let yOffset = (boundingRect.height - blockSize * CGFloat(rows)) / 2
        
        //loading color before render
        let gameboard = self.snakeGame.gameBoard
        
        return ForEach(0...cols - 1, id: \.self) { col in
            ForEach(0...rows - 1, id: \.self) { row in
                Path { path in
                    let x = xOffset + blockSize * CGFloat(col)
                    let y = boundingRect.height - yOffset - blockSize * CGFloat(row + 1)
                    
                    let rect = CGRect(x: x, y: y, width: blockSize, height: blockSize)
                    
                    path.addRect(rect)
                }
                .fill(gameboard[col][row].color)
                .onTapGesture {
                    self.snakeGame.snakeGameModel.blockClicked(col: col, row: row)
                }
                
            }
        }
    }
    
}

struct SnakeGameView_Previews: PreviewProvider {
    static var previews: some View {
        SnakeGameView()
    }
}
