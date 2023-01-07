//
//  WeatherRealmObjects.swift
//  Weather map
//
//  Created by Oleksii on 05.01.2023.
//

import Foundation
import RealmSwift

class RealmWeatherItem: Object {
    
    @Persisted var temperature: Int = 0
    @Persisted var windSpeed: Double = 0
    @Persisted var humidity: Int = 0
    @Persisted var iconId: Int = 20
    @Persisted var date: Double = 0
    @Persisted var cityName: String = ""
}

extension WeatherItem {
    
    func realmObject(for city: String) -> RealmWeatherItem {
        
        let obj = RealmWeatherItem()
        
        obj.temperature = temperature
        obj.windSpeed = windSpeed
        obj.humidity = humidity
        obj.iconId = iconId
        obj.date = date.timeIntervalSince1970
        obj.cityName = city
        
        return obj
    }
    
    init(realmObject: RealmWeatherItem) {
        
        self.init(temperature: realmObject.temperature,
                  windSpeed: realmObject.windSpeed,
                  humidity: realmObject.humidity,
                  iconId: realmObject.iconId,
                  date: Date(timeIntervalSince1970: realmObject.date))
    }
}
