//
//  ShortWeatherData.swift
//  Weather map
//
//  Created by Oleksii on 02.01.2023.
//

import Foundation
import UIKit

struct ShortWeatherData {
    
    let temeprature: Int
    let iconId: Int
    let date: Date
}

extension ShortWeatherData {
    
    var icon: UIImage { .weatherIcon(with: iconId) }
    
    var hour: String {
        
        let hour = Calendar.current.component(.hour, from: date)
        
        return "\(hour).00"
    }
    
    var weekDay: String {
        
        let dateFormatter = with(DateFormatter(), completion: { $0.dateFormat = "EEEE" })
        return dateFormatter.string(from: date)
    }
}
