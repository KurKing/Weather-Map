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

    func data(for location: CLLocationCoordinate2D) -> WeatherMapPinData? {
        
        return .init(icon: .sunWithCloudsWeatherIcon, temperature: 27)
    }
}
