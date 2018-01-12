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
    @IBOutlet weak var pointsTextView: UITextView!
    @IBOutlet weak var highScoreTextView: UITextView!
    @IBOutlet weak var gameView: UIView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var exitButton: UIButton!
    
    // MARK: - VARIABLES -
    
    var imageSize: CGSize!
    var imagesArray: [UIImageView]!
    
    var isPressed = false
    
    var pointAudioPlayer: AVAudioPlayer!
    var looseAudioPlayer: AVAudioPlayer!
    var pauseAudioPlayer: AVAudioPlayer!
    var recordAudioPlayer: AVAudioPlayer!
    
    // MARK: - VIEWCONTROLLER METHODS -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GameManager.singleton.delegate = self
        
        // Set buttons correctly
        exitButton.isHidden = true
        highScoreTextView.text = String(UserDefaults.standard.integer(forKey: "highScore"))
        
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
        imageSize = CGSize(width: maximumWidth/CGFloat(GameManager.singleton.numColums), height: maximumHeight/CGFloat(GameManager.singleton.numRows))
        
        // Adjusting the gameView size for each iPhone
        let biggestCoordinate = coordinateToPixels(x: GameManager.singleton.numColums, y: GameManager.singleton.numRows)
        
        gameView.frame.size = CGSize(width: biggestCoordinate[0], height: biggestCoordinate[1])
        gameView.center = CGPoint(x: self.view.frame.width/2 + menuView.frame.width/2, y: self.view.frame.height/2)
        
        // Initializing array
        imagesArray = [UIImageView]()
        
        // Calls the method to start the Game
        GameManager.singleton.startGame()
        
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
    }
    
    // MARK: - BUTTONS ACTION -
    
    /// Make the pause Menu visible
    ///
    /// - Parameter sender:
    @IBAction func pauseButtonPressed(_ sender: Any) {
        
        if !GameManager.singleton.gameIsOver {
            
            // When the button is to resume game
            if isPressed {
                GameManager.singleton.resumeGame()
                exitButton.isHidden = true
                pauseButton.setImage(UIImage(named: "pauseButton"), for: .normal)
                isPressed = false
                
            } else { // When the button is to pause the game
                GameManager.singleton.pauseGame()
                exitButton.isHidden = false
                pauseButton.setImage(UIImage(named: "resumeButton"), for: .normal)
                isPressed = true
                pauseAudioPlayer.play()
            }
            
        } else { // When the button is to restart the game
            pauseButton.setImage(UIImage(named: "pauseButton"), for: .normal)
            exitButton.isHidden = true
            GameManager.singleton.restartGame()
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
                GameManager.singleton.changeDirection(directionToChange: .up)
                
            case UISwipeGestureRecognizerDirection.right:
                GameManager.singleton.changeDirection(directionToChange: .right)
                
            case UISwipeGestureRecognizerDirection.down:
                GameManager.singleton.changeDirection(directionToChange: .down)
                
            case UISwipeGestureRecognizerDirection.left:
                GameManager.singleton.changeDirection(directionToChange: .left)
            
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
        
        // Removes all old frames
        self.imagesArray.forEach { image in
            image.removeFromSuperview()
        }
        
        imagesArray.removeAll()
    }
    
    /// Draws the right image in the screen
    ///
    /// - Parameters:
    ///   - x: x coordinate to draw in the map
    ///   - y: y coordinate to draw in the map
    ///   - image: name of the image that should be draw
    func draw(x: Int, y: Int, image: String) {
        
        let coordinate = coordinateToPixels(x: x, y: y)
        
        imagesArray.append(UIImageView(image: UIImage(named: image)))
        imagesArray.last?.frame = CGRect(origin: CGPoint(x: coordinate[0], y: coordinate[1]), size: imageSize)
        self.gameView.addSubview(self.imagesArray.last!)
    }
    
    /// Called when the snake ate the food
    func ateFood() {
        pointsTextView.text = String(GameManager.singleton.score)
        pointAudioPlayer.play()
    }
    
    /// Called when the game ends
    func gameOver() {
        
        // Checks if the high score was beaten
        if UserDefaults.standard.integer(forKey: "highScore") < GameManager.singleton.score {
            UserDefaults.standard.set(GameManager.singleton.score, forKey: "highScore")
            highScoreTextView.text = String(GameManager.singleton.score)
            recordAudioPlayer.play()
        } else {
            looseAudioPlayer.play()
        }
        
        // Set buttons correctly
        pauseButton.setImage(UIImage(named: "restartButton"), for: .normal)
        exitButton.isHidden = false
    }
}
