//
//  WeatherService.swift
//  Weather map
//
//  Created by Oleksii on 24.12.2022.
//

import Foundation
import CoreLocation
import RxSwift
import RxRelay

class WeatherService {
    
    var weatherPinCreationStream: Observable<CLLocationCoordinate2D> {
        _weatherPinCreationStream.compactMap({ $0 }).asObservable()
    }
    private let _weatherPinCreationStream = BehaviorRelay<CLLocationCoordinate2D?>(value: nil)
    
    private var weather: [String: CityWeatherModel] = [:]
    
    private let remoteWeatherStorage = RemoteWeatherStorage()
    private let localWeatherStorage = LocalWeatherStorage()
    
    private let disposeBag = DisposeBag()
    
    private let isRefreshEnabled: Bool
    
    init() {
        let appWasEverLauched = UserDefaults.standard.bool(forKey: "appWasEverLauched")
        UserDefaults.standard.set(true, forKey: "appWasEverLauched")
        
        isRefreshEnabled = appWasEverLauched
    }
    
    func data(for location: CLLocationCoordinate2D) -> WeatherMapPinData? {
        
        guard let weatherItem = weather[location.stringRepresentation]?.weatherList.first else {
            
            return nil
        }
        
        return .init(icon: weatherItem.icon, temperature: weatherItem.temperature)
    }
    
    func cityWeather(for location: CLLocationCoordinate2D) -> CityWeatherModel? {
        
        return weather[location.stringRepresentation]
    }
    
    func fetchWeather(for city: City) {
        
        let localWeather = localWeatherStorage.weather(for: city.name)
        
        if !localWeather.isEmpty {
            
            self.weather[city.location.stringRepresentation] = .init(city: city.name,
                                                                     weatherList: localWeather)
            
            self._weatherPinCreationStream.accept(city.location)
            
            return
        }
        
        remoteWeatherStorage
            .fetch(latitude: city.latitude,
                   longitude: city.longitude)
            .subscribe(onNext: { [weak self] weatherList in
                
                guard let self = self else { return }
                
                self.weather[city.location.stringRepresentation] = .init(city: city.name,
                                                                         weatherList: weatherList)
                
                self.localWeatherStorage.save(weather: weatherList, for: city.name)
                
                self._weatherPinCreationStream.accept(city.location)
            }).disposed(by: self.disposeBag)
    }
    
    func refreshData(for cities: [City]) {
        
        guard isRefreshEnabled else { return }
        
        cities.forEach({ city in
            
            if let weather = weather[city.location.stringRepresentation],
               weather.isOutdated {
                
                remoteWeatherStorage
                    .fetch(latitude: city.latitude,
                           longitude: city.longitude)
                    .subscribe(onNext: { [weak self] weatherList in
                        
                        guard let self = self,
                              let cityWeatherList = self.weather[
                                city.location.stringRepresentation]?.weatherList else {
                            
                            return
                        }
                        
                        if let lastItem = cityWeatherList.last {
                            
                            let itemsToAdd = weatherList.filter({ $0.date > lastItem.date })
                
                            self.weather[city.location.stringRepresentation]?
                                .weatherList
                                .append(contentsOf: itemsToAdd)
                            self.localWeatherStorage.save(weather: itemsToAdd, for: city.name)
                        } else {
                            
                            self.weather[city.location.stringRepresentation]?.weatherList = weatherList
                            self.localWeatherStorage.save(weather: weatherList, for: city.name)
                        }
                    }).disposed(by: self.disposeBag)
            }
        })
    }
}
