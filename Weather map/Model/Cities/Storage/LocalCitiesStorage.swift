//
//  LocalCitiesStorage.swift
//  Weather map
//
//  Created by Oleksii on 05.01.2023.
//

import Foundation
import CoreLocation
import RealmSwift
import RxSwift
import RxRelay

class LocalCitiesStorage {
    
    private let realm = try! Realm()
    
    var fetchedCoordinates = [CLLocationCoordinate2D]()
    var citiesSteam: Observable<City> { _citiesStream.asObservable() }
    var cities = [City]()
    
    private let _citiesStream = PublishRelay<City>()
    
    init() {
        
        realm.objects(RealmCoordinates.self)
            .map({ CLLocationCoordinate2D(realmObject: $0) })
            .forEach({ fetchedCoordinates.append($0) })
    }
    
    func fetchCities() {
        
        realm.objects(RealmCity.self)
            .map({ City(realmObject: $0) })
            .forEach({
                
                _citiesStream.accept($0)
                cities.append($0)
            })
    }
    
    func save(coordinate: CLLocationCoordinate2D) {
        
        let realm = realm
        let realmObject = coordinate.realmObject
        
        realm.writeAsync({
            
            realm.add(realmObject)
        })
    }
    
    func save(city: City) {
        
        let realm = realm
        let realmObject = city.realmObject
        
        realm.writeAsync({
            
            realm.add(realmObject)
        })
    }
}
