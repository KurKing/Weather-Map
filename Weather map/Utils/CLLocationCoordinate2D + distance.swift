//
//  CLLocationCoordinate2D + distance.swift
//  Weather map
//
//  Created by Oleksii on 24.12.2022.
//

import MapKit

extension CLLocationCoordinate2D {
    
    func distance(to coordinate: CLLocationCoordinate2D) -> Double {
        
        let x1 = latitude
        let y1 = longitude
        
        let x2 = coordinate.latitude
        let y2 = coordinate.longitude
        
        return sqrt((x2-x1)*(x2-x1)+(y2-y1)*(y2-y1))
    }
    
    static var zero: CLLocationCoordinate2D {
        
        .init(latitude: 0, longitude: 0)
    }
}
