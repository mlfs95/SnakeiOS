//
//  Wall.swift
//  Snake
//
//  Created by Matheus Lourenco Fernandes Soares on 12/01/2018.
//  Copyright © 2018 Matheus Lourenco Fernandes Soares. All rights reserved.
//

import Foundation

class Level {
    
    // MARK: - VARIABLES -
    
    // Array of wall coordinates
    var xWall: [Int]!
    var yWall: [Int]!
    
    // Number of walls in the level
    var numberOfBlocks: Int!
    // Number of points to get to the next level
    var maxPoints: Int!
    
    /// Initializes the level by passing the wanted level number
    ///
    /// - Parameter level: Level number
    init(level: Int) {
        
        // Gets the Level.plist as a dictionary
        let myDict = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "Levels", ofType: "plist")!)
        
        // Gets the dictionary of the wanted level
        let levelInformations = myDict!["Level\(level)"] as! [String:Any]
        
        // Sets variables acording to the right level
        numberOfBlocks = levelInformations["NumberOfBlocks"] as! Int
        maxPoints = levelInformations["MaxPoints"] as! Int
        
        if numberOfBlocks > 0 {
            xWall = levelInformations["x"] as! [Int]
            yWall = levelInformations["y"] as! [Int]
        }
    }
}
