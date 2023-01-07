//
//  Analytics.swift
//  Weather map
//
//  Created by Oleksii on 07.01.2023.
//

import Foundation
import Firebase
import FirebaseAnalytics

class WeatherAnalytics {
    
    func logAppLaunched() {
        
        Analytics.logEvent("APP_LAUNCHED", parameters: nil)
    }
    
    func logMapAppeared() {
        
        Analytics.logEvent("MAP_APPEARED", parameters: nil)
    }
    
    func logOpenCityDetailsEvent(city: String) {
        
        Analytics.logEvent("OPEN_CITY_DETAILS", parameters: ["City": city])
    }
    
    func logFetchCity(on location: String) {
        
        Analytics.logEvent("FETCH_CITY", parameters: ["Location": location])
    }
    
    func logFetchWeather(on location: String) {
        
        Analytics.logEvent("FETCH_WEATHER", parameters: ["Location": location])
    }
}
