//
//  Snake.swift
//  Snake
//
//  Created by Matheus Lourenco Fernandes Soares on 07/01/2018.
//  Copyright © 2018 Matheus Lourenco Fernandes Soares. All rights reserved.
//

import Foundation

class Snake {
    
    // MARK: - VARIABLES -
    
    // Snekes body coordinate.
    // The first element of the array will always be the tail and the last will always be the head.
    public var bodyX: [Int]!
    public var bodyY: [Int]!
    
    public var headX: Int!
    public var headY: Int!
    
    public var lenght: Int!
    
    public var direction: Direction
    
    // MARK: - CONSTRUCTOR -
    
    // initializing the snake with a lenght of 3 in the start position
    init(){
        bodyX = [Int]()
        bodyY = [Int]()
        
        bodyX.append(2)
        bodyY.append(9)
        
        bodyX.append(3)
        bodyY.append(9)
        
        headX = 4
        headY = 9
        
        lenght = 3
        
        direction = .right
    }
    
    // MARK: - METHODS -
    
    func moveSnake(ateFood: Bool) {
        
        switch direction {
            
        case .up:
            
            bodyX.append(headX)
            bodyY.append(headY)
            headY = headY - 1
            
        case .right:
            bodyX.append(headX)
            bodyY.append(headY)
            headX = headX + 1
            
        case .down:
            bodyX.append(headX)
            bodyY.append(headY)
            headY = headY + 1
            
        case .left:
            bodyX.append(headX)
            bodyY.append(headY)
            headX = headX - 1
            
        default:
            break
        }
        
        if !ateFood {
            bodyX.removeFirst()
            bodyY.removeFirst()
        } else {
            lenght = lenght + 1
        }
    }
}


