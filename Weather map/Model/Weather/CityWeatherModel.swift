//
//  CityWeatherModel.swift
//  Weather map
//
//  Created by Oleksii on 26.12.2022.
//

import Foundation

class CityWeatherModel {

    let city: City
    var weatherList: [WeatherItem]
    
    init(city: City, weatherList: [WeatherItem] = [WeatherItem]()) {
        
        self.city = city
        self.weatherList = weatherList
    }
}
