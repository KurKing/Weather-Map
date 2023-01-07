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
    private var dataToDelete = [RealmWeatherItem]()
    
    func weather(for city: String) -> [WeatherItem] {
        
        realm.objects(RealmWeatherItem.self)
            .where({ $0.cityName == city  })
            .compactMap({ [weak self] weatherItem in
                
                if Date(timeIntervalSince1970: weatherItem.date) < Date() {
                    
                    if let self = self {
                        
                        self.dataToDelete.append(weatherItem)
                        
                        if self.dataToDelete.count > 500 {
                            
                            let dataToDelete = dataToDelete
                            let realm = self.realm
                            
                            self.dataToDelete = []
                            
                            realm.writeAsync { dataToDelete.forEach({ realm.delete($0) }) }
                        }
                    }
                    
                    return nil
                }
                
                return WeatherItem(realmObject: weatherItem)
            })
    }
    
    func save(weather: [WeatherItem], for city: String) {
        
        let realm = realm

        realm.writeAsync({
            
            weather.forEach({ realm.add($0.realmObject(for: city)) })
        })
    }
}

