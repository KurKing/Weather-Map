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

struct WeatherMapPinData {
    
    let icon: UIImage
    let temperature: Int
}

protocol MapViewModelProtocol {
    
    var weatherPinCreationStream: Observable<CLLocationCoordinate2D> { get }
    var mapCenter: BehaviorRelay<CLLocationCoordinate2D> { get }
    
    func viewDidLoad()
    func data(for location: CLLocationCoordinate2D) -> WeatherMapPinData?
    func cityWeather(for location: CLLocationCoordinate2D) -> CityWeatherModel?
}

class MapViewModel: MapViewModelProtocol {
    
    let mapCenter = BehaviorRelay<CLLocationCoordinate2D>(value: .zero)
    
    var weatherPinCreationStream: Observable<CLLocationCoordinate2D> {
        
        weatherService.weatherPinCreationStream
    }
    
    private let disposeBag = DisposeBag()
    
    private let citiesSevice = CitiesService()
    private let weatherService = WeatherService()
    
    private var lastRefreshedLocation: CLLocationCoordinate2D?
    
    init() {
        
        mapCenter.skip(1)
            .subscribe(onNext: { [weak self] location in
                
                guard let self = self else { return }
                
                self.citiesSevice.getCities(for: location)
                
                if self.lastRefreshedLocation == nil ||
                self.lastRefreshedLocation!.distance(to: location) > 100000 {
                    
                    let visibleCities = self.citiesSevice.localCities(for: location)
                    self.weatherService.refreshData(for: visibleCities)
                    self.lastRefreshedLocation = location
                }
            }).disposed(by: disposeBag)
        
        citiesSevice.citiesSteam.subscribe(onNext: { [weak self] city in
            
            self?.weatherService.fetchWeather(for: city)
        }).disposed(by: disposeBag)
    }
    
    func viewDidLoad() {
        
        citiesSevice.startFetch()
    }
    
    func data(for location: CLLocationCoordinate2D) -> WeatherMapPinData? {
        
        weatherService.data(for: location)
    }
    
    func cityWeather(for location: CLLocationCoordinate2D) -> CityWeatherModel? {
        
        weatherService.cityWeather(for: location)
    }
}
