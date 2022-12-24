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
    private let locationManager = CLLocationManager()
    
    override init() {
        
        super.init()
        
        locationManager.delegate = self
    }
    
    func requestAuthorization(with closure: ((CLLocationCoordinate2D)->())? = nil) {
        
        onGetLocation = closure
        
        locationManager.requestWhenInUseAuthorization()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    
        if let location = manager.location?.coordinate {
            
            onGetLocation?(location)
        }
    }
}
