//
//  ArcadeManager.swift
//  Snake
//
//  Created by Matheus Lourenco Fernandes Soares on 12/01/2018.
//  Copyright © 2018 Matheus Lourenco Fernandes Soares. All rights reserved.
//

import Foundation

class ArcadeManager: GameManager {
    
    // MARK: - Singleton -
    static let singleton: ArcadeManager = ArcadeManager()
    
    // MARK: - Variables -
    public var difficulty: Difficulty!
    
    //MARK: - OVERRIDE METHODS -
    
    /// Initializes snake and food, calls the functions to draw them, sets variables correctly and sets the timer
    override func startGame() {
        
        // Creates the food and the snake instances
        snake = Snake()
        food = Food(maxX: numColums, maxY: numRows)
        
        // Setting variables to initial state
        score = 0
        gameIsOver = false
        
        // Draws the first frame of the game
        drawFood()
        drawSnake()
        
        startTimer()
    }
    
    /// Starts a timer depending on the difficulty selected by the user in the initial
    override func startTimer() {
        
        switch difficulty {
            
        case .easy:
            timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) {_ in
                self.makeNewFrame()
            }
            
        case .medium:
            timer = Timer.scheduledTimer(withTimeInterval: 0.175, repeats: true) {_ in
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
    
    /// Make the snake class moves and eat the food if it is in the right coordinate
    override func checksSnakeState() {
        
        // If the snake eats the food
        if snake.headX == food.x && snake.headY == food.y {
            
            // We add 1 point and we tell the interface
            score += 1
            delegate.ateFood()
            
            // Move the snake eating the food and get a new food
            snake.moveSnake(ateFood: true)
            
            generateNewFood()
            
        } else {
            
            // Move the snake without eating the food
            snake.moveSnake(ateFood: false)
        }
    }
    
    
    /// Creates a new food and checks if it is not on a snake coordinate 
    override func generateNewFood() {
        
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
    }
    
    /// Checks if the snake went into a wall or itself calling gameOver()
    override func checkGameEnds() {
        
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
    }
}
