//
//  CityWeatherModel.swift
//  Weather map
//
//  Created by Oleksii on 26.12.2022.
//

import Foundation

class CityWeatherModel {
    
    let city: String
    var weatherList: [WeatherItem]
    
    var isOutdated: Bool { weatherList.count < 35 }
    
    init(city: String, weatherList: [WeatherItem] = [WeatherItem]()) {
        
        self.city = city
        self.weatherList = weatherList
    }
}
