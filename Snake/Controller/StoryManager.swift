//
//  StoryManager.swift
//  Snake
//
//  Created by Matheus Lourenco Fernandes Soares on 12/01/2018.
//  Copyright © 2018 Matheus Lourenco Fernandes Soares. All rights reserved.
//

import Foundation

class StoryManager: GameManager {
    
    // MARK: - Singleton -
    static let singleton: StoryManager = StoryManager()
    
    // MARK: - VARIABLES -
    var level: Level!
    var levelNumber = 1
    
    func drawWalls() {
        
        if level.numberOfBlocks > 0 {
            for i in 0...level.numberOfBlocks-1 {
                
                // Calls the delegate function to draw the food on the view
                delegate.drawPermanentImage(x: level.xWall[i], y: level.yWall[i], image: "wall")
            }
        }
    }
    
    
    //MARK: - OVERRIDE METHODS -
    
    /// Initializes snake, food and level walls, calls the functions to draw them, sets variables correctly and sets the timer
    override func startGame() {
        
        // Setting variables to initial state
        score = 0
        gameIsOver = false
        
        // Creates the food and the snake instances
        snake = Snake()
        level = Level(level: levelNumber)
        food = Food(maxX: numColums, maxY: numRows)
        
        generateNewFood()
        
        // Draws the first frame of the game
        drawFood()
        drawSnake()
        drawWalls()
        
        startTimer()
    }
    
    /// Starts a timer to draw new frames
    override func startTimer() {
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) {_ in
            self.makeNewFrame()
        }
    }
    
    /// Checks if snake ate food, makes snake move correctly and checks if the level was beaten
    override func checksSnakeState() {
        
        // If the snake eats the food
        if snake.headX == food.x && snake.headY == food.y {
            
            // We add 1 point and we tell the interface
            score += 1
            
            if score == level.maxPoints {
                
                delegate.newLevel()
                
                levelNumber += 1
                timer.invalidate()
                
                startGame()
            } else {
                delegate.ateFood()
                
                // Move the snake eating the food and get a new food
                snake.moveSnake(ateFood: true)
                
                generateNewFood()
            }
        } else {
            
            // Move the snake without eating the food
            snake.moveSnake(ateFood: false)
        }
    }
    
    /// Creates new food on a random position and makes sure it's not on the snake or in a level wall
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
            
            if level.numberOfBlocks > 0 {
                for i in 0 ... level.numberOfBlocks - 1 {
                    if level.xWall[i] == food.x && level.yWall[i] == food.y {
                        print("oops thats a wall")
                        continue GenerateNewFood
                    }
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
    
    /// Controls if the snake has died by eating herself, bumping into a level wall or outside the map
    override func checkGameEnds() {
        
        // If the next movement was into the snake itself
        for i in 0 ... snake.lenght - 2 {
            if snake.bodyX[i] == snake.headX && snake.bodyY[i] == snake.headY {
                gameOver()
            }
        }
        
        // If the next movement was into a wall
        if level.numberOfBlocks > 0 {
            for i in 0 ... level.numberOfBlocks - 1 {
                if level.xWall[i] == snake.headX && level.yWall[i] == snake.headY {
                    gameOver()
                }
            }
        }
        
        // If the next movement was into a wall
        if snake.headX > 29 || snake.headX < 0 || snake.headY > 19 || snake.headY < 0 {
            gameOver()
        }
    }
}

