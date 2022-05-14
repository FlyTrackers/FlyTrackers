//
//  AppDelegate.swift
//  FlyTrackers
//
//  Created by Elliott Larsen on 3/15/22.
//

import UIKit
import Parse
import Security

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // UserDefaults isn't secure, figure out KeyChain.
        // This stores the ClientKey and APIKey in UserDefaults.... no good since can be easily accessed
        let defaults = UserDefaults.standard
        
        if defaults.string(forKey: "APIKey") == nil {
            defaults.set(ProcessInfo.processInfo.environment["APP_ID"]!, forKey: "APIKey")
        }
        
        if defaults.string(forKey: "ClientKey") == nil {
            defaults.set(ProcessInfo.processInfo.environment["CLIENT_KEY"]!, forKey: "ClientKey")
        }
        
        defaults.synchronize()
        let apiKey = defaults.string(forKey: "APIKey")
        let clientKey = defaults.string(forKey: "ClientKey")
        
        // Parse Connection
        let parseConfig = ParseClientConfiguration {
            $0.applicationId = apiKey
            $0.clientKey = clientKey
            $0.server = "https://parseapi.back4app.com"
        }
        
        Parse.initialize(with: parseConfig)
        
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

