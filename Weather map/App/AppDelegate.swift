//
//  AppDelegate.swift
//  Weather map
//
//  Created by Oleksii on 18.12.2022.
//

import UIKit
import RealmSwift
import Firebase
import FirebaseCore
import FirebaseAnalytics
import FirebaseCrashlytics
import FirebaseRemoteConfig
import FirebaseRemoteConfigSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        #if DEBUG
        if let realmFileUrl = Realm.Configuration.defaultConfiguration.fileURL?.absoluteString {
            
            print("Realm file: \(realmFileUrl)")
        }
        #endif
        
        FirebaseApp.configure()
        
        WeatherAnalytics().logAppLaunched()
        
        let remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
