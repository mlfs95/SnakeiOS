//
//  AppDelegate.swift
//  Snake
//
//  Created by Matheus Lourenco Fernandes Soares on 06/01/2018.
//  Copyright © 2018 Matheus Lourenco Fernandes Soares. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Saves locally the high score
        let easyHighScore = UserDefaults.standard.integer(forKey: "eastHighScore")
        let mediumHighScore = UserDefaults.standard.integer(forKey: "mediumHighScore")
        let hardHighScore = UserDefaults.standard.integer(forKey: "hardHighScore")
        
        // Initialize if hasn't been already
        if easyHighScore == 0 && mediumHighScore == 0 && hardHighScore == 0 {
            UserDefaults.standard.set(0, forKey: "easyHighScore")
            UserDefaults.standard.set(0, forKey: "mediumHighScore")
            UserDefaults.standard.set(0, forKey: "hardHighScore")
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

