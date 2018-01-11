//
//  GameManager.swift
//  Snake
//
//  Created by Matheus Lourenco Fernandes Soares on 07/01/2018.
//  Copyright © 2018 Matheus Lourenco Fernandes Soares. All rights reserved.
//

import Foundation

class GameManager {
    
    // MARK: - Singleton -
    static let singleton: GameManager = GameManager()
    
    // MARK: - Delegate -
    public var delegate: GameManagerDelegate!
    
    // MARK: - Variables -
    private var snake: Snake!
    private var food: Food!
    private var timer: Timer!
    
    public var score = 0
    public var difficulty: Difficulty!
    
    public var numColums = 30
    public var numRows = 20
    
    private var lockedDirection: Bool!
    public var gameIsOver: Bool!
    
    // MARK: - CONSTRUCTOR -
    
    init() {
        lockedDirection = false
        gameIsOver = false
    }
    
    // MARK: - METHODS -
    
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
                
            default:
                break
            }
        }
    }
    
    /// Sets up the beggining of the game and calls the timer to make the movement of the snake
    func startGame() {
        
        // Creates the food and the snake instances
        snake = Snake()
        food = Food(maxX: numColums, maxY: numRows)
        
        // Setting variables to initial state
        score = 0
        gameIsOver = false
        
        // Draws the first frame of the game
        drawEverything()
        
        startTimer()
    }
    
    /// Starts the timer with with the right interval for the right difficulty
    func startTimer() {
        
        switch difficulty {
            
        case .easy:
            timer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true) {_ in
                self.makeNewFrame()
            }
            
        case .medium:
            timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) {_ in
                self.makeNewFrame()
            }
            
        case .hard:
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) {_ in
                self.makeNewFrame()
            }
            
        default:
            break
        }
    }
    
    /// Creates the new frame of the game
    func makeNewFrame() {
        
        // If the snake eats the food
        if snake.headX == food.x && snake.headY == food.y {
            
            // We add 1 point and we tell the interface
            score += 1
            delegate.ateFood()
            
            // Move the snake eating the food and get a new food
            snake.moveSnake(ateFood: true)
            
            // Generates new food on a non snake position
            GenerateNewFood: while (true) {
                
                // Generates on a random place
                food.getNextFood(maxX: numColums, maxY: numRows)
                
                // Checks for each body part if the position is the same as the new food
                for i in 0 ... snake.lenght - 2 {
                    // If it is the while continues
                    if snake.bodyX[i] == food.x && snake.bodyY[i] == food.y {
                        print("oops thats a body")
                        continue GenerateNewFood
                    }
                }
                
                // if the food is in the place of the head the while continues
                if snake.headX == food.x && snake.headY == food.y {
                    print("oops thats the head")
                    continue GenerateNewFood
                }
                
                // If not breaks the while
                break GenerateNewFood
            }
        } else {
            
            // Move the snake without eating the food
            snake.moveSnake(ateFood: false)
        }
        
        // If the next movement was into the snake itself
        for i in 0 ... snake.lenght - 2 {
            if snake.bodyX[i] == snake.headX && snake.bodyY[i] == snake.headY {
                gameOver()
            }
        }
        
        // If the next movement was into a wall
        if snake.headX > 29 || snake.headX < 0 || snake.headY > 19 || snake.headY < 0 {
            gameOver()
        }
        
        // If the game didn't end
        if !gameIsOver {
            
            // Informs the view that a new frame is being made
            delegate.willMakeNewFrame()
            drawEverything()
        }
    }
    
    /// Draws every part of the body of the snake and the food
    func drawEverything() {
        
        // Calls the delegate function to draw the food on the view
        delegate.draw(x: food.x, y: food.y, image: "food")
        
        // For every coordinate of the body of the snake we call the delegate function so the view can be updated
        for i in 0 ... snake.lenght - 2 {
            delegate.draw(x: snake.bodyX[i], y: snake.bodyY[i], image: "snakeBody")
        }
        
        // Calls the delegate function with the right image depending on the direction of the snake
        switch snake.direction {
        case .up:
            delegate.draw(x: snake.headX, y: snake.headY, image: "headUp")
            
        case .right:
            delegate.draw(x: snake.headX, y: snake.headY, image: "headRight")
            
        case .down:
            delegate.draw(x: snake.headX, y: snake.headY, image: "headDown")
            
        case .left:
            delegate.draw(x: snake.headX, y: snake.headY, image: "headLeft")
            
        default:
            break
        }
        
        // Unlocks the direction
        lockedDirection = false
    }
    
    /// Called when the user pauses the game
    func pauseGame() {
        timer.invalidate()
        
        // locking direction so the player can't change direction in pause
        lockedDirection = true
    }
    
    /// Called when the player unpause the game
    func resumeGame() {
        lockedDirection = false
        makeNewFrame()
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
}












