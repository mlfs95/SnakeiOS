//
//  GameManager.swift
//  Snake
//
//  Created by Matheus Lourenco Fernandes Soares on 07/01/2018.
//  Copyright © 2018 Matheus Lourenco Fernandes Soares. All rights reserved.
//

import Foundation

class GameManager {
    
    // MARK: - DELEGATE -
    public var delegate: GameManagerDelegate!
    
    // MARK: - VARIABLES -
    public var snake: Snake!
    public var food: Food!
    public var timer: Timer!
    
    public var score = 0
    public var mode: Mode!
    
    public var numColums = 30
    public var numRows = 20
    
    public var lockedDirection: Bool!
    public var gameIsOver: Bool!
    
    // MARK: - CONTROL METHODS -
    
    /// Changes the direction the snake is going
    ///
    /// - Parameter directionToChange: The direction the snake should change
    func changeDirection(directionToChange: Direction) {
        
        // If the player hasn't tried changing direction in this frame already
        if !lockedDirection {
            
            // Changes the direction the snake is going if it's not oposite to the current direction and locks changes in the frame
            switch snake.direction {
                
            case .up:
                if directionToChange != .down {
                    snake.direction = directionToChange
                    lockedDirection = true
                }
                
            case .right:
                if directionToChange != .left {
                    snake.direction = directionToChange
                    lockedDirection = true
                }
                
            case .down:
                if directionToChange != .up {
                    snake.direction = directionToChange
                    lockedDirection = true
                }
                
            case .left:
                if directionToChange != .right {
                    snake.direction = directionToChange
                    lockedDirection = true
                }
            }
        }
    }
    
    // Called when the user pauses the game
    func pauseGame() {
        timer.invalidate()
        
        // locking direction so the player can't change direction in pause
        lockedDirection = true
    }
    
    /// Called when the player unpause the game
    func resumeGame() {
        lockedDirection = false
        startTimer()
    }
    
    /// Called to restart the game
    func restartGame() {
        delegate.willMakeNewFrame()
        startGame()
    }
    
    /// Called when the game ends
    func gameOver() {
        
        // tells the interface the game has ended
        self.delegate.gameOver()
        
        // Stops calling function makeNewFrame
        timer.invalidate()
        
        gameIsOver = true
    }
    
    // MARK: - DRAWING METHODS -
    
    /// Creates the new frame of the game
    func makeNewFrame() {
        
        checksSnakeState()
        checkGameEnds()
        
        // If the game didn't end
        if !gameIsOver {
            
            // Informs the view that a new frame is being made
            delegate.willMakeNewFrame()
            
            drawFood()
            drawSnake()
            
            // Unlocks the direction
            lockedDirection = false
        }
    }
    
    /// Calls the delegate function to draw the food on the view
    func drawFood() {
        
        delegate.drawTemporaryImage(x: food.x, y: food.y, image: "food")
    }
    
    /// Calls the delegate function to draw every part of the snake
    func drawSnake() {
        // For every coordinate of the body of the snake we call the delegate function so the view can be updated
        for i in 0 ... snake.lenght - 2 {
            delegate.drawTemporaryImage(x: snake.bodyX[i], y: snake.bodyY[i], image: "snakeBody")
        }
        
        // Calls the delegate function with the right image depending on the direction of the snake
        switch snake.direction {
        case .up:
            delegate.drawTemporaryImage(x: snake.headX, y: snake.headY, image: "headUp")
            
        case .right:
            delegate.drawTemporaryImage(x: snake.headX, y: snake.headY, image: "headRight")
            
        case .down:
            delegate.drawTemporaryImage(x: snake.headX, y: snake.headY, image: "headDown")
            
        case .left:
            delegate.drawTemporaryImage(x: snake.headX, y: snake.headY, image: "headLeft")
        }
    }
    
    // MARK: - OVERRIDE METHODS -
    
    /// Sets up the beggining of the game and calls the timer to make the movement of the snake
    func startGame() {
        //
        //      THIS METHOD MUST BE OVERRIDEN BY THE SUBCLASS
        //
        fatalError("This method must be overridden")
        //
        //      THIS METHOD MUST BE OVERRIDEN BY THE SUBCLASS
        //
    }
    
    /// Starts the timer with with the right interval for the right difficulty
    func startTimer() {
        //
        //      THIS METHOD MUST BE OVERRIDEN BY THE SUBCLASS
        //
        fatalError("This method must be overridden")
        //
        //      THIS METHOD MUST BE OVERRIDEN BY THE SUBCLASS
        //
    }
    
    /// Makes the changes it has to make in the model to draw correctly
    func checksSnakeState() {
        //
        //      THIS METHOD MUST BE OVERRIDEN BY THE SUBCLASS
        //
        fatalError("This method must be overridden")
        //
        //      THIS METHOD MUST BE OVERRIDEN BY THE SUBCLASS
        //
    }
    
    /// Generates and chacks if the food spawned in a valid place
    func generateNewFood() {
        //
        //      THIS METHOD MUST BE OVERRIDEN BY THE SUBCLASS
        //
        fatalError("This method must be overridden")
        //
        //      THIS METHOD MUST BE OVERRIDEN BY THE SUBCLASS
        //
    }
    
    /// Makes all the verifications if the game is still going
    func checkGameEnds() {
        //
        //      THIS METHOD MUST BE OVERRIDEN BY THE SUBCLASS
        //
        fatalError("This method must be overridden")
        //
        //      THIS METHOD MUST BE OVERRIDEN BY THE SUBCLASS
        //
    }
}












