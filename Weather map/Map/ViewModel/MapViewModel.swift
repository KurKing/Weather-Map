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
    func cityWeather(for location: CLLocationCoordinate2D) -> CityWeatherModel?
}

class MapViewModel: MapViewModelProtocol {
    
    var weatherPinCreationStream: Observable<CLLocationCoordinate2D> {
        _weatherPinCreationStream.compactMap({ $0 }).asObservable()
    }
    private let _weatherPinCreationStream = BehaviorRelay<CLLocationCoordinate2D?>(value: nil)
    
    let mapCenter = BehaviorRelay<CLLocationCoordinate2D>(value: .zero)
    
    private let disposeBag = DisposeBag()
    
    private var weather: [String: CityWeatherModel] = [:]
    let weatherStorage = RemoteWeatherStorage()
    
    private let citiesSevice = CitiesService()
    
    init() {
        
        bindToObservers()
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
    
    private func bindToObservers() {
        
        mapCenter.skip(1)
            .subscribe(onNext: { [weak self] location in
            
            self?.citiesSevice.getCities(for: location)
        }).disposed(by: disposeBag)
        
        citiesSevice.citiesSteam.subscribe(onNext: { [weak self] city in
            
            self?.fetchWeather(for: city)
        }).disposed(by: disposeBag)
    }
    
    private func fetchWeather(for city: City) {
        
        weatherStorage
            .fetch(latitude: city.latitude,
                   longitude: city.longitude)
            .subscribe(onNext: { [weak self] weatherList in
                
                guard let self = self else { return }
                
                self.weather[city.location.stringRepresentation] = .init(city: city,
                                                                         weatherList: weatherList)
                
                self._weatherPinCreationStream.accept(city.location)
            }).disposed(by: self.disposeBag)
    }
}
