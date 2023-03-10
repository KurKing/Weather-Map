//
//  CLLocationCoordinate2D.swift
//  Weather map
//
//  Created by Oleksii on 24.12.2022.
//

import MapKit

extension CLLocationCoordinate2D {
    
    static var zero: CLLocationCoordinate2D { .init(latitude: 0, longitude: 0) }
    
    var stringRepresentation: String { "\(latitude) \(longitude)" }
    
    func distance(to coordinate: CLLocationCoordinate2D) -> Double {
        
        let location1 = CLLocation(coordinate: self)
        let location2 = CLLocation(coordinate: coordinate)
        
        return location1.distance(from: location2)
    }
}

extension CLLocation {
    
    convenience init(coordinate: CLLocationCoordinate2D) {
        
        self.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
}

extension CLLocationCoordinate2D: Equatable {
    
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        
        lhs.longitude == rhs.longitude && lhs.latitude == rhs.latitude
    }
}
