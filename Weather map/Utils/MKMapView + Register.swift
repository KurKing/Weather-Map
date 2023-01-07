//
//  MKMapView + Register.swift
//  Weather map
//
//  Created by Oleksii on 24.12.2022.
//

import MapKit

extension MKMapView {
    
    func register<T: MKAnnotationView>(_: T.Type) {
        
        let identifier = NSStringFromClass(T.self)
        register(T.self, forAnnotationViewWithReuseIdentifier: identifier)
    }
    
    func dequeueReusableView<T: MKAnnotationView>(type: T.Type) -> T {
        
        let identifier = NSStringFromClass(T.self)
        
        guard let view = dequeueReusableAnnotationView(withIdentifier: identifier) as? T else {
            
            fatalError("Could not dequeue cell with identifier: \(identifier)")
        }
        
        return view
    }
}
