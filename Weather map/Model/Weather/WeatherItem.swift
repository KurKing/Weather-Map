//
//  WeatherItem.swift
//  Weather map
//
//  Created by Oleksii on 26.12.2022.
//

import UIKit
import SwiftyJSON

struct WeatherItem {
    
    let temperature: Int
    let windSpeed: Double
    let humidity: Int
    let iconId: Int
    let date: Date
    
    init(temperature: Int, windSpeed: Double, humidity: Int, iconId: Int, date: Date) {
        
        self.temperature = temperature
        self.windSpeed = windSpeed
        self.humidity = humidity
        self.iconId = iconId
        self.date = date
    }
    
    init?(json: JSON) {
        
        guard let temperature = json["main"]["temp"].double,
              let windSpeed = json["wind"]["speed"].double,
              let humidity = json["main"]["humidity"].int,
              let weatherIconId = json["weather"].array?.first?["id"].int?.toWeatherIconId,
              let date = json["dt"].int else {
            
            return nil
        }
        
        self.init(temperature: Int(temperature),
                  windSpeed: windSpeed,
                  humidity: humidity,
                  iconId: weatherIconId,
                  date: .init(timeIntervalSince1970: Double(date)))
    }
}

// MARK: - WeatherItem utils

extension WeatherItem {
    
    var icon: UIImage { .weatherIcon(with: iconId) }
}

fileprivate extension Int {
    
    var toWeatherIconId: Int? {
        
        switch self {
        case 200..<300:
            return 23
        case 501...502:
            return 3
        case 300..<600:
            return 24
        case 600..<700:
            return 6
        case 700..<800:
            return 29
        case 800:
            return 20
        case 801:
            return 1
        case 802...804:
            return 26
        default:
            return nil
        }
    }
}
