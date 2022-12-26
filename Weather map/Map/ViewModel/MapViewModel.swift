//
//  MapViewModel.swift
//  Weather map
//
//  Created by Oleksii on 24.12.2022.
//

import Foundation
import RxSwift
import RxRelay
import CoreLocation

protocol MapViewModelProtocol {
    
    var weatherPinCreationStream: Observable<CLLocationCoordinate2D> { get }
    var mapCenter: BehaviorRelay<CLLocationCoordinate2D> { get }
    
    func data(for location: CLLocationCoordinate2D) -> WeatherMapPinData?
}

class MapViewModel: MapViewModelProtocol {
    
    var weatherPinCreationStream: Observable<CLLocationCoordinate2D> {
        
        _weatherPinCreationStream.compactMap({ $0 }).asObservable()
    }
    private let _weatherPinCreationStream = BehaviorRelay<CLLocationCoordinate2D?>(value: nil)
    
    let mapCenter = BehaviorRelay<CLLocationCoordinate2D>(value: .zero)
    
    private let disposeBag = DisposeBag()
    private var lastUpdateCoordinate: CLLocationCoordinate2D?
    
    private var cities: [String: City] = [:]
    private var weather: [String: WeatherItem] = [:]
    
    init() {
        
        bindToMapCenter()
    }

    func data(for location: CLLocationCoordinate2D) -> WeatherMapPinData? {
        
        guard let weatherItem = weather[location.stringRepresentation] else {
            
            return nil
        }
        
        return .init(icon: weatherItem.icon, temperature: weatherItem.temperature)
    }
    
    private func bindToMapCenter() {
        
        mapCenter.subscribe(onNext: { [weak self] location in
            
            guard let self = self else { return }
            
            if let lastUpdateCoordinate = self.lastUpdateCoordinate {
                
                if lastUpdateCoordinate.distance(to: location) > 250000 {
                    
                    self.fetchInfo(for: location)
                }
                
                return
            }
            
            self.fetchInfo(for: location)
        }).disposed(by: disposeBag)
    }
    
    let citiesStorage = RemoteCitiesStorage()
    let weatherStorage = RemoteWeatherStorage()

    private func fetchInfo(for location: CLLocationCoordinate2D) {
        
        lastUpdateCoordinate = location
        
        citiesStorage.fetch(latitude: location.latitude, longitude: location.longitude)
            .subscribe(onNext: { [weak self] newCities in
                
                guard let self = self else { return }
                
                newCities.filter({ self.cities[$0.name] == nil })
                    .forEach({ city in
                        
                        self.cities[city.name] = city
                        
                        self.weatherStorage.fetch(latitude: city.latitude, longitude: city.longitude)
                            .subscribe(onNext: { [weak self] weatherItem in
                                
                                guard let self = self else { return }
                                
                                self.weather[city.location.stringRepresentation] = weatherItem
                                self._weatherPinCreationStream.accept(.init(latitude: city.latitude,
                                                                            longitude: city.longitude))
                            }).disposed(by: self.disposeBag)
                        
                    })
            }).disposed(by: disposeBag)
    }
}
