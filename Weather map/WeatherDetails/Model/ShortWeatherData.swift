//
//  ShortWeatherData.swift
//  Weather map
//
//  Created by Oleksii on 02.01.2023.
//

import Foundation
import UIKit

struct ShortWeatherData {
    
    let temperature: Int
    let iconId: Int
    let date: Date
    
    init(temperature: Int, iconId: Int, date: Date) {
        self.temperature = temperature
        self.iconId = iconId
        self.date = date
    }
}

extension ShortWeatherData {
    
    var icon: UIImage { .weatherIcon(with: iconId) }
    
    var hour: String {
        
        let dateFormatter =  with(DateFormatter()) {
            
            $0.dateFormat = "h:mm"
            $0.locale = .init(identifier: "en_US")
        }
        
        return dateFormatter.string(from: date)
    }
    
    var weekDay: String {
        
        let dateFormatter = with(DateFormatter(), completion: {
            
            $0.dateFormat = "EEEE"
            $0.locale = .init(identifier: "en_US")
        })
        
        return dateFormatter.string(from: date)
    }
}

// MARK: - Mapper
extension ShortWeatherData {
    
    init(weatherItem: WeatherItem) {
        
        temperature = weatherItem.temperature
        iconId = weatherItem.iconId
        date = weatherItem.date
    }
}
