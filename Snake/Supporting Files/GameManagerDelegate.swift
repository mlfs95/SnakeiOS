//
//  GameManagerDelegate.swift
//  Snake
//
//  Created by Matheus Lourenco Fernandes Soares on 07/01/2018.
//  Copyright © 2018 Matheus Lourenco Fernandes Soares. All rights reserved.
//

import Foundation

protocol GameManagerDelegate {
    
    /// Called when the Game is ready to make a new frame
    func willMakeNewFrame()
    
    /// Called to draw something that changes position in the interface
    ///
    /// - Parameters:
    ///   - x: X coordinate to draw
    ///   - y: Y coordinate to draw
    ///   - image: Name of the image to draw
    func drawTemporaryImage(x: Int, y: Int, image: String)
    
    /// Called to draw something that remains in the interface all the time
    ///
    /// - Parameters:
    ///   - x: X coordinate to draw
    ///   - y: Y coordinate to draw
    ///   - image: Name of the image to draw
    func drawPermanentImage(x: Int, y: Int, image: String)
    
    /// Called when the level changes
    func newLevel()
    
    /// Called when the snake ate a food
    func ateFood()
    
    /// Called when the game ends
    func gameOver()
}

extension GameManagerDelegate {
    
    func willMakeNewFrame() { print("Will draw new frame") }
    
    func drawTemporaryImage(x: Int, y: Int, image: String) { print("Drawing with image named: \(image)") }
    
    func drawPermanentImage(x: Int, y: Int, image: String) { print("Drawing permanently image named: \(image)") }
    
    func newLevel() { print("New Level will load") }
    
    func ateFood() { print("the snake Ate food") }
    
    func gameOver() { print("Game Over") }
    
}
