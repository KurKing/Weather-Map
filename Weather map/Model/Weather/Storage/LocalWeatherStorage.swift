//
//  LocalWeatherStorage.swift
//  Weather map
//
//  Created by Oleksii on 05.01.2023.
//

import Foundation
import CoreLocation
import RealmSwift
import RxSwift
import RxRelay

class LocalWeatherStorage {
    
    private let realm = try! Realm()
    
    func weather(for city: String) -> [WeatherItem] {
        
        realm.objects(RealmWeatherItem.self)
            .filter({ $0.cityName == city })
            .map({ WeatherItem(realmObject: $0) })
    }
    
    func save(weather: WeatherItem, for city: String) {
        
        let realm = realm
        let realmObject = weather.realmObject(for: city)
        
        realm.writeAsync({
            
            realm.add(realmObject)
        })
    }
}

