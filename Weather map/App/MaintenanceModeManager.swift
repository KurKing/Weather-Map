//
//  MaintenanceModeManager.swift
//  Weather map
//
//  Created by Oleksii on 07.01.2023.
//

import Foundation
import Firebase
import FirebaseRemoteConfig
import FirebaseRemoteConfigSwift

class MaintenanceModeManager {
    
    var maintenanceModeIsEnabled: Bool {
        
        RemoteConfig.remoteConfig().configValue(forKey: "maintenanceMode").boolValue
    }
    
    func setup() {
        
        try? RemoteConfig.remoteConfig().setDefaults(from: ["maintenanceMode": false])
        RemoteConfig.remoteConfig().fetchAndActivate()
    }
}
