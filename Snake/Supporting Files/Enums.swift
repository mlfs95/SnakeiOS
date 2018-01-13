//
//  Enums.swift
//  Snake
//
//  Created by Matheus Lourenco Fernandes Soares on 08/01/2018.
//  Copyright © 2018 Matheus Lourenco Fernandes Soares. All rights reserved.
//

import Foundation

/// Enum to set the difficulty of the game
///
/// - easy: In easy we have a frame every 3 seconds
/// - medium: In medium we have a frame every 2 seconds
/// - hard: In hard we have a frame in every 1 second
public enum Difficulty {
    case easy
    case medium
    case hard
}

/// Enum to inform what direction the snake is going
///
/// - up: If it is going up
/// - right: If it is going right
/// - down: If it is going down
/// - left: If it is going left
public enum Direction {
    case up
    case right
    case down
    case left
}

/// Enum to inform what game mode the player will play
///
/// - arcade: if it is arcade mode
/// - story: if it is story mode
public enum Mode {
    case arcade
    case story
}
