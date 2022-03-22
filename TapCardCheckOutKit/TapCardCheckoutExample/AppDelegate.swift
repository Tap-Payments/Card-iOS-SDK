//
//  AppDelegate.swift
//  TapCardCheckoutExample
//
//  Created by Osama Rabie on 21/03/2022.
//

import UIKit
import TapCardCheckOutKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let cardDataConfig:TapCardDataConfiguration = .init(sdkMode: .sandbox, localeIdentifier: "en", secretKey: .init(sandbox: "sk_test_cvSHaplrPNkJO7dhoUxDYjqA", production: "sk_live_V4UDhitI0r7sFwHCfNB6xMKp"))
        //TapCardForumConfiguration.shared.configure(dataConfig: cardDataConfig, customLocalisation: .init(shouldFlip:true,localeIdentifier: "ar"))
        TapCardForumConfiguration.shared.configure(dataConfig: cardDataConfig)
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

