//
//  UIImage + Constants.swift
//  Weather map
//
//  Created by Oleksii on 24.12.2022.
//

import UIKit

extension UIImage {
    
    static var mapPin: UIImage { .init(named: "MapPin-Image")! }
    
    static var location: UIImage { .init(named: "Location-Image")! }
    
    static var sunWithCloudsWeatherIcon: UIImage { .init(named: "SunWithClouds-Image")! }
    
    static func weatherIcon(with id: Int) -> UIImage {
        
        guard let icon = UIImage(named: "Weather-\(id)-icon") else {
            
            fatalError("Weather icon with id \(id) not found.")
        }
        
        return icon
    }
}
