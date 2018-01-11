//
//  Food.swift
//  Snake
//
//  Created by Matheus Lourenco Fernandes Soares on 07/01/2018.
//  Copyright © 2018 Matheus Lourenco Fernandes Soares. All rights reserved.
//

import Foundation

class Food {
    
    // MARK: - VARIABLES -
    
    // Coordinate of the food
    public var x: Int!
    public var y: Int!
    
    // MARK: - CONSTRUCTOR -
    
    // Initializing the food in the start position
    init(maxX: Int, maxY: Int) {
        
        self.x = Int(arc4random_uniform(UInt32(maxX)))
        self.y = Int(arc4random_uniform(UInt32(maxY)))
    }
    
    //MARK: - METHODS -
    
    
    /// Randomly chooses a new position for the food
    func getNextFood(maxX: Int, maxY: Int) {
        x = Int(arc4random_uniform(UInt32(maxX)))
        y = Int(arc4random_uniform(UInt32(maxY)))
    }
}
