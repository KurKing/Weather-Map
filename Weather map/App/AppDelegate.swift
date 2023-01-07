//
//  AppDelegate.swift
//  Weather map
//
//  Created by Oleksii on 18.12.2022.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        #if DEBUG
        
        if let realmFileConfiguration = Realm.Configuration.defaultConfiguration.fileURL?.absoluteString {
            
            print("Realm file: \(realmFileConfiguration)")
        } else {
            
            print("Warning! Realm file is not exist")
        }
        
        #endif

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {

        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
