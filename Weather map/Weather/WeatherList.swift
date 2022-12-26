//
//  WeatherList.swift
//  Weather map
//
//  Created by Oleksii on 26.12.2022.
//

import Foundation

class WeatherList {

    let cityName: String
    var weatherList: [WeatherItem]
    
    init(cityName: String, weatherList: [WeatherItem] = [WeatherItem]()) {
        
        self.cityName = cityName
        self.weatherList = weatherList
    }
}
