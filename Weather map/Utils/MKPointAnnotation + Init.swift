//
//  MKPointAnnotation + Init.swift
//  Weather map
//
//  Created by Oleksii on 18.12.2022.
//

import MapKit

extension MKPointAnnotation {
    
    static func pinInCenter(of map: MKMapView) -> MKPointAnnotation {
        
        let pin = MKPointAnnotation()
        pin.coordinate = map.centerCoordinate
        
        return pin
    }
}
