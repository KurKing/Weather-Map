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
            .where({ $0.cityName == city  })
            .compactMap({ city in
                
                if Date(timeIntervalSince1970: city.date) < Date() {
                    
                    let realm = realm
                    realm.writeAsync { realm.delete(city) }
                    
                    return nil
                }
                
                return WeatherItem(realmObject: city)
            })
    }
    
    func save(weather: [WeatherItem], for city: String) {
        
        let realm = realm

        realm.writeAsync({
            
            weather.forEach({ realm.add($0.realmObject(for: city)) })
        })
    }
}

