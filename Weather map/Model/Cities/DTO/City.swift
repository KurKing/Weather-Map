//
//  City.swift
//  Weather map
//
//  Created by Oleksii on 24.12.2022.
//

import Foundation
import CoreLocation
import SwiftyJSON

struct City {

    let name: String
    let latitude: Double
    let longitude: Double
    
    var location: CLLocationCoordinate2D {
        
        .init(latitude: latitude, longitude: longitude)
    }
    
    init?(json: JSON) {
        
        guard let name = json["name"].string,
              let latitude = json["latitude"].double,
              let longitude = json["longitude"].double else {
            
            return nil
        }
        
        self.init(name: name, latitude: latitude, longitude: longitude)
    }
    
    init(name: String, latitude: Double, longitude: Double) {
        
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
}
