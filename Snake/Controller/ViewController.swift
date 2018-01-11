//
//  ViewController.swift
//  Snake
//
//  Created by Matheus Lourenco Fernandes Soares on 06/01/2018.
//  Copyright © 2018 Matheus Lourenco Fernandes Soares. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - OUTLETS -
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var snakeLabel: UILabel!
    
    // MARK: - VIEWCONTROLLER METHODS -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startFadeIn()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        highScoreLabel.text = String(UserDefaults.standard.integer(forKey: "highScore"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startFadeOut() {
        
        UIView.animate(withDuration: 1, animations: {
            self.snakeLabel.alpha = 0
            
        }) { (true) in
            
            self.startFadeIn()
        }
    }
    
    func startFadeIn() {
        
        UIView.animate(withDuration: 1, animations: {
            self.snakeLabel.alpha = 1
            
        }) { (true) in
            
            self.startFadeOut()
        }
    }

    // MARK: - BUTTON ACTION -
    
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
        
        GameManager.singleton.difficulty = difficulty
        
        self.performSegue(withIdentifier: "GameSegue", sender: nil)
    }
}

