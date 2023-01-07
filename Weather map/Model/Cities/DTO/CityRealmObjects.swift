//
//  CityRealmObjects.swift
//  Weather map
//
//  Created by Oleksii on 05.01.2023.
//

import Foundation
import RealmSwift
import CoreLocation

// MARK: Coordinates

class RealmCoordinates: Object {
    
    @Persisted var latitude: Double = 0
    @Persisted var longitude: Double = 0
}

extension CLLocationCoordinate2D {
    
    var realmObject: RealmCoordinates {
        
        let obj = RealmCoordinates()
        
        obj.latitude = latitude
        obj.longitude = longitude
        
        return obj
    }
    
    init(realmObject: RealmCoordinates) {
        
        self.init(latitude: realmObject.latitude,
                  longitude: realmObject.longitude)
    }
}

// MARK: City

class RealmCity: Object {

    @Persisted var name: String = ""
    @Persisted var latitude: Double = 0
    @Persisted var longitude: Double = 0
}

extension City {
    
    var realmObject: RealmCity {
        
        let obj = RealmCity()
        
        obj.name = name
        obj.latitude = latitude
        obj.longitude = longitude
        
        return obj
    }
    
    init(realmObject: RealmCity) {
        
        self.init(name: realmObject.name,
                  latitude: realmObject.latitude,
                  longitude: realmObject.longitude)
    }
}
