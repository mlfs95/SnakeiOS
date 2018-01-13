//
//  ViewController.swift
//  Snake
//
//  Created by Matheus Lourenco Fernandes Soares on 06/01/2018.
//  Copyright © 2018 Matheus Lourenco Fernandes Soares. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController {

    // MARK: - OUTLETS -
    
    // Game title
    @IBOutlet weak var snakeLabel: UILabel!
    
    // Game mode menu buttons
    @IBOutlet weak var arcadeModeButton: UIButton!
    @IBOutlet weak var storyModeButton: UIButton!
    
    // Arcade difficulty menu buttons and labels
    @IBOutlet weak var difficultHighScoreLabel: UILabel!
    @IBOutlet weak var mediumHighScoreLabel: UILabel!
    @IBOutlet weak var easyHighScoreLabel: UILabel!
    @IBOutlet weak var difficultButton: UIButton!
    @IBOutlet weak var mediumButton: UIButton!
    @IBOutlet weak var easyButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    // MARK: - VARIABLES -
    
    var audioPlayer = AVAudioPlayer()
    
    // MARK: - VIEWCONTROLLER METHODS -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Gets the URL of the music
        let filePath = Bundle.main.path(forResource: "snakeMusic", ofType: "mp3")
        let fileURL = NSURL.fileURL(withPath: filePath!)
        
        // Sets up the music player correctly and starts playing the music
        do {
            audioPlayer = try AVAudioPlayer.init(contentsOf: fileURL, fileTypeHint: AVFileType.mp3.rawValue)
            audioPlayer.numberOfLoops = -1
            audioPlayer.volume = 0.05
            audioPlayer.play()
        } catch {
            print("Couldn't play the music")
        }
        
        // Starts fadeIn/FadeOut animation of the label's title
        startSnakeFadeIn()
    }
    
    // Every time this view appear it refreshes the high scores
    override func viewDidAppear(_ animated: Bool) {
        easyHighScoreLabel.text = String(UserDefaults.standard.integer(forKey: "easyHighScore"))
        mediumHighScoreLabel.text = String(UserDefaults.standard.integer(forKey: "mediumHighScore"))
        difficultHighScoreLabel.text = String(UserDefaults.standard.integer(forKey: "hardHighScore"))
    }
    
    // MARK: - ANIMATION METHODS -
    
    /// Animation of the game title fading out
    func startSnakeFadeOut() {
        
        UIView.animate(withDuration: 1, animations: {
            self.snakeLabel.alpha = 0
            
        }) { (true) in
            
            self.startSnakeFadeIn()
        }
    }
    
    /// Animation of the fame title fading in
    func startSnakeFadeIn() {
        
        UIView.animate(withDuration: 1, animations: {
            self.snakeLabel.alpha = 1
            
        }) { (true) in
            
            self.startSnakeFadeOut()
        }
    }

    // MARK: - BUTTON ACTION -
    
    /// Fade out and fade in animation of the buttons in the screen appearing the difficulties of the arcade mode
    ///
    /// - Parameter sender:
    @IBAction func arcadeModeButtonPressed(_ sender: Any) {
        
        UIView.animate(withDuration: 0.5, animations: {
            
            self.arcadeModeButton.alpha = 0
            self.storyModeButton.alpha = 0
        }) { (true) in
            
            self.arcadeModeButton.isHidden = true
            self.storyModeButton.isHidden = true
            
            self.easyHighScoreLabel.isHidden = false
            self.mediumHighScoreLabel.isHidden = false
            self.difficultHighScoreLabel.isHidden = false
            
            self.easyButton.isHidden = false
            self.mediumButton.isHidden = false
            self.difficultButton.isHidden = false
            
            self.backButton.isHidden = false
            
            UIView.animate(withDuration: 0.5, animations: {
                self.easyHighScoreLabel.alpha = 1
                self.mediumHighScoreLabel.alpha = 1
                self.difficultHighScoreLabel.alpha = 1
                
                self.easyButton.alpha = 1
                self.mediumButton.alpha = 1
                self.difficultButton.alpha = 1
                
                self.backButton.alpha = 1
            })
        }
    }
    
    
    /// Fade out and fade in animation of the buttons in the screen appearing the initial menu
    ///
    /// - Parameter sender:
    @IBAction func backButtonPressed(_ sender: Any) {
        
        UIView.animate(withDuration: 0.5, animations: {
            self.easyHighScoreLabel.alpha = 0
            self.mediumHighScoreLabel.alpha = 0
            self.difficultHighScoreLabel.alpha = 0
            
            self.easyButton.alpha = 0
            self.mediumButton.alpha = 0
            self.difficultButton.alpha = 0
            
            self.backButton.alpha = 0
            
        }) { (true) in
            
            self.arcadeModeButton.isHidden = false
            self.storyModeButton.isHidden = false
            
            self.easyHighScoreLabel.isHidden = true
            self.mediumHighScoreLabel.isHidden = true
            self.difficultHighScoreLabel.isHidden = true
            
            self.easyButton.isHidden = true
            self.mediumButton.isHidden = true
            self.difficultButton.isHidden = true
            
            self.backButton.isHidden = true
            
            UIView.animate(withDuration: 0.5, animations: {
                self.arcadeModeButton.alpha = 1
                self.storyModeButton.alpha = 1
            })
        }
    }
    /// Called when the easy difficulty button is selected
    ///
    /// - Parameter sender:
    @IBAction func easyButtonTapped(_ sender: Any) {
        
        startGame(difficulty: .easy)
    }
    
    /// Called when the medium difficulty button is selected
    ///
    /// - Parameter sender:
    @IBAction func mediumButtonTapped(_ sender: Any) {
        
        startGame(difficulty: .medium)
    }
    
    /// Called when the hard difficulty button is selected
    ///
    /// - Parameter sender:
    @IBAction func difficultButtonTapped(_ sender: Any) {
        
        startGame(difficulty: .hard)
    }
    
    // MARK: - METHODS -
    
    /// Creates a instance of game if the right difficulty and calls the GameViewController
    ///
    /// - Parameter difficulty: the difficulty of the new game selected by the user
    func startGame(difficulty: Difficulty) {
        
        ArcadeManager.singleton.difficulty = difficulty
        
        self.performSegue(withIdentifier: "arcadeSegue", sender: nil)
    }
    
    /// Teels the GameViewController wich game mode the player will play
    ///
    /// - Parameters:
    ///   - segue:
    ///   - sender: 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let gameViewController = segue.destination as? GameViewController {
            
            if segue.identifier == "storySegue" {
                gameViewController.gameMode = .story
            }
            
            if segue.identifier == "arcadeSegue" {
                gameViewController.gameMode = .arcade
            }
        }
    }
}

