//
//  LocationManager.swift
//  Weather map
//
//  Created by Oleksii on 24.12.2022.
//

import Foundation
import CoreLocation

class LocationManager: NSObject {
    
    private var onGetLocation: ((CLLocationCoordinate2D)->())?
    private var isAutorized = false
    
    private let locationManager = CLLocationManager()
    
    override init() {
        
        super.init()
        
        locationManager.delegate = self
    }
    
    func requestAuthorization(with closure: @escaping((CLLocationCoordinate2D)->())) {
        
        if !isAutorized {
            
            onGetLocation = closure
            locationManager.requestWhenInUseAuthorization()
            
            return
        }
        
        if let location = locationManager.location?.coordinate {
            
            closure(location)
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        isAutorized = true
        
        if let location = manager.location?.coordinate {
            
            onGetLocation?(location)
        }
    }
}
