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
    
    init() {
        
        bindToMapCenter()
    }

    func data(for location: CLLocationCoordinate2D) -> WeatherMapPinData? {
        
        return .init(icon: .sunWithCloudsWeatherIcon, temperature: 27)
    }
    
    private func bindToMapCenter() {
        
        mapCenter.subscribe(onNext: { [weak self] location in
            
            guard let self = self else { return }
            
            if let lastUpdateCoordinate = self.lastUpdateCoordinate {
                
                if lastUpdateCoordinate.distance(to: location) > 3 {
                    
                    self.fetchInfo(for: location)
                }
                
                return
            }
            
            self.fetchInfo(for: location)
        }).disposed(by: disposeBag)
    }
    
    let storage = RemoteCitiesStorage()

    private func fetchInfo(for location: CLLocationCoordinate2D) {
        lastUpdateCoordinate = location
        
        storage.request(latitude: location.latitude, longitude: location.longitude)
            .subscribe(onNext: { [weak self] newCities in
                
                guard let self = self else { return }
                
                newCities.filter({ self.cities[$0.name] == nil })
                    .forEach({
                        self.cities[$0.name] = $0
                        self._weatherPinCreationStream.accept(.init(latitude: $0.latitude, longitude: $0.longitude))
                    })
                
            }).disposed(by: disposeBag)
    }
}
