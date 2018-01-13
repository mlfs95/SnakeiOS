//
//  GameViewController.swift
//  Snake
//
//  Created by Matheus Lourenco Fernandes Soares on 07/01/2018.
//  Copyright © 2018 Matheus Lourenco Fernandes Soares. All rights reserved.
//

import UIKit
import AVKit

class GameViewController: UIViewController, GameManagerDelegate {

    // MARK: - OUTLETS -
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var objectiveLabel: UILabel!
    @IBOutlet weak var gameView: UIView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var exitButton: UIButton!
    
    // MARK: - VARIABLES -
    
    var imageSize: CGSize!
    var temporaryImagesArray: [UIImageView]!
    var permanentImagesArray: [UIImageView]!
    
    var isPressed = false
    var gameManager: GameManager!
    
    var gameMode: Mode!
    
    // Audio variables
    var pointAudioPlayer: AVAudioPlayer!
    var looseAudioPlayer: AVAudioPlayer!
    var pauseAudioPlayer: AVAudioPlayer!
    var recordAudioPlayer: AVAudioPlayer!
    
    // MARK: - VIEWCONTROLLER METHODS -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initializes the right singleton as the gameManager
        switch gameMode {
            
        case .arcade:
            gameManager = ArcadeManager.singleton
            
        case .story:
            gameManager = StoryManager.singleton
            
        default:
            print("This should not have happened")
        }
        
        // Set buttons correctly
        exitButton.isHidden = true
        
        // Creates gesture recognizers to change direction of snake
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.didSwipe))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        self.view.addGestureRecognizer(swipeUp)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.didSwipe))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.didSwipe))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.view.addGestureRecognizer(swipeDown)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.didSwipe))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        
        // Calculating the maximum size of the gameView
        let maximumHeight = self.view.frame.height - 10
        let maximumWidth = self.view.frame.width - menuView.frame.width - 10
        
        // Saving the CGSize of each block painted in the game
        imageSize = CGSize(width: maximumWidth/CGFloat(gameManager.numColums), height: maximumHeight/CGFloat(gameManager.numRows))
        
        // Adjusting the gameView size for each iPhone
        let biggestCoordinate = coordinateToPixels(x: gameManager.numColums, y: gameManager.numRows)
        
        gameView.frame.size = CGSize(width: biggestCoordinate[0], height: biggestCoordinate[1])
        gameView.center = CGPoint(x: self.view.frame.width/2 + menuView.frame.width/2, y: self.view.frame.height/2)
        
        // Initializing array
        temporaryImagesArray = [UIImageView]()
        permanentImagesArray = [UIImageView]()
        
        // Gets the URL of the sounds
        let pointFileURL = NSURL.fileURL(withPath: Bundle.main.path(forResource: "pointSound", ofType: "wav")!)
        let looseFileURL = NSURL.fileURL(withPath: Bundle.main.path(forResource: "looseSound", ofType: "wav")!)
        let pauseFileURL = NSURL.fileURL(withPath: Bundle.main.path(forResource: "pauseSound", ofType: "wav")!)
        let recordFileURL = NSURL.fileURL(withPath: Bundle.main.path(forResource: "recordSound", ofType: "wav")!)
        
        // Sets up the sounds player correctly
        do {
            pointAudioPlayer = try AVAudioPlayer(contentsOf: pointFileURL, fileTypeHint: AVFileType.wav.rawValue)
            pointAudioPlayer.volume = 0.3
            looseAudioPlayer = try AVAudioPlayer(contentsOf: looseFileURL, fileTypeHint: AVFileType.wav.rawValue)
            looseAudioPlayer.volume = 0.3
            pauseAudioPlayer = try AVAudioPlayer(contentsOf: pauseFileURL, fileTypeHint: AVFileType.wav.rawValue)
            pauseAudioPlayer.volume = 0.3
            recordAudioPlayer = try AVAudioPlayer(contentsOf: recordFileURL, fileTypeHint: AVFileType.wav.rawValue)
            recordAudioPlayer.volume = 0.3
        } catch {
            print("Couldn't initialize the sounds")
        }
        
        // Setups the game according to the right game mode
        switch gameMode {
            
        case .arcade:
            ArcadeManager.singleton.delegate = self
            ArcadeManager.singleton.startGame()
            objectiveLabel.text = "Melhor\nPontuação"
            
            // Gets the local high score for the right difficulty
            switch ArcadeManager.singleton.difficulty {
                
            case .easy:
                highScoreLabel.text = String(UserDefaults.standard.integer(forKey: "easyHighScore"))
                
            case .medium:
                highScoreLabel.text = String(UserDefaults.standard.integer(forKey: "mediumHighScore"))
                
            case .hard:
                highScoreLabel.text = String(UserDefaults.standard.integer(forKey: "hardHighScore"))
                
            default:
                print("This should not have happened")
            }
            
            
        case .story:
            StoryManager.singleton.delegate = self
            StoryManager.singleton.startGame()
            objectiveLabel.text = "Objetivo"
            
            // Sets the objective gap to the next level
            highScoreLabel.text = String(StoryManager.singleton.level.maxPoints)
            
        default:
            print("This should not have happened")
        }
    }
    
    // MARK: - BUTTONS ACTION -
    
    /// Make the pause Menu visible
    ///
    /// - Parameter sender:
    @IBAction func pauseButtonPressed(_ sender: Any) {
        
        if !gameManager.gameIsOver {
            
            // When the button is to resume game
            if isPressed {
                gameManager.resumeGame()
                exitButton.isHidden = true
                pauseButton.setImage(UIImage(named: "pauseButton"), for: .normal)
                isPressed = false
                
            } else { // When the button is to pause the game
                gameManager.pauseGame()
                exitButton.isHidden = false
                pauseButton.setImage(UIImage(named: "resumeButton"), for: .normal)
                isPressed = true
                pauseAudioPlayer.play()
            }
            
        } else { // When the button is to restart the game
            pauseButton.setImage(UIImage(named: "pauseButton"), for: .normal)
            exitButton.isHidden = true
            pointsLabel.text = "0"
            gameManager.restartGame()
        }
        
    }
    
    /// Exits the GameViewController
    ///
    /// - Parameter sender:
    @IBAction func exitButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - METHODS -
    
    /// Handles the swipe gesture
    ///
    /// - Parameter swipe: the gesture made by the user
    @objc func didSwipe(swipe: UIGestureRecognizer) {
        if let swipeGesture = swipe as? UISwipeGestureRecognizer {
            
            
            // changes the direction of the snake
            switch swipeGesture.direction {
                
            case UISwipeGestureRecognizerDirection.up:
                gameManager.changeDirection(directionToChange: .up)
                
            case UISwipeGestureRecognizerDirection.right:
                gameManager.changeDirection(directionToChange: .right)
                
            case UISwipeGestureRecognizerDirection.down:
                gameManager.changeDirection(directionToChange: .down)
                
            case UISwipeGestureRecognizerDirection.left:
                gameManager.changeDirection(directionToChange: .left)
            
            default:
                break
            }
        }
    }
    
    /// Method that transforms a coordinate into the right position in the map
    ///
    /// - Parameters:
    ///   - x: x coordinate
    ///   - y: y coordinate
    /// - Returns: An array of pixel coordinate in which the first element is the x pixel and the second is the y pixel
    private func coordinateToPixels(x: Int, y: Int) -> [Int] {
        
        let pixelsX = Int(imageSize.width) * x
        let pixelsY = Int(imageSize.height) * y
        
        return [pixelsX, pixelsY]
    }
    
    // MARK: - GAMEMANAGERDELEGATE METHODS -
    
    /// Called whenever a new frame began to be made
    func willMakeNewFrame() {
        
        // Removes last frame temporary images
        self.temporaryImagesArray.forEach { image in
            image.removeFromSuperview()
        }
        
        temporaryImagesArray.removeAll()
    }
    
    /// Draws a image that will be out in the next frame
    ///
    /// - Parameters:
    ///   - x: x coordinate to draw in the map
    ///   - y: y coordinate to draw in the map
    ///   - image: name of the image that should be draw
    func drawTemporaryImage(x: Int, y: Int, image: String) {
        
        let coordinate = coordinateToPixels(x: x, y: y)
        
        temporaryImagesArray.append(UIImageView(image: UIImage(named: image)))
        temporaryImagesArray.last?.frame = CGRect(origin: CGPoint(x: coordinate[0], y: coordinate[1]), size: imageSize)
        self.gameView.addSubview(self.temporaryImagesArray.last!)
    }
    
    
    /// Draws a image that won't be out for a good amount of frames
    ///
    /// - Parameters:
    ///   - x: x coordinate to draw in the map
    ///   - y: y coordinate to draw in the map
    ///   - image: name of the image that should be draw
    func drawPermanentImage(x: Int, y: Int, image: String) {
        
        let coordinate = coordinateToPixels(x: x, y: y)
        
        permanentImagesArray.append(UIImageView(image: UIImage(named: image)))
        permanentImagesArray.last?.frame = CGRect(origin: CGPoint(x: coordinate[0], y: coordinate[1]), size: imageSize)
        self.gameView.addSubview(self.permanentImagesArray.last!)
    }
    
    /// Called when the snake ate the food
    func ateFood() {
        pointsLabel.text = String(gameManager.score)
        pointAudioPlayer.play()
    }
    
    /// Called when the player passed the level in Story mode
    func newLevel() {
        
        pointsLabel.text = "0"
        highScoreLabel.text = String(StoryManager.singleton.level.maxPoints)
        recordAudioPlayer.play()
        
        // Removes old map images
        self.permanentImagesArray.forEach { image in
            image.removeFromSuperview()
        }
        
        permanentImagesArray.removeAll()
    }
    
    /// Called when the game ends
    func gameOver() {
        
        if gameMode == .arcade {
            
            // Checks if the high score was beaten
            if Int(highScoreLabel.text!)! < ArcadeManager.singleton.score {
                
                switch ArcadeManager.singleton.difficulty {
                    
                case .easy:
                    UserDefaults.standard.set(ArcadeManager.singleton.score, forKey: "easyHighScore")
                    
                case .medium:
                    UserDefaults.standard.set(ArcadeManager.singleton.score, forKey: "mediumHighScore")
                    
                case .hard:
                    UserDefaults.standard.set(ArcadeManager.singleton.score, forKey: "hardHighScore")
                    
                default:
                    print("This should not have happended")
                }
                highScoreLabel.text = String(ArcadeManager.singleton.score)
                recordAudioPlayer.play()
            } else {
                
                looseAudioPlayer.play()
            }
        } else {
            
            looseAudioPlayer.play()
        }
        
        // Set buttons correctly
        pauseButton.setImage(UIImage(named: "restartButton"), for: .normal)
        exitButton.isHidden = false
    }
}
