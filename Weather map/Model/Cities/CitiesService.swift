//
//  CitiesService.swift
//  Weather map
//
//  Created by Oleksii on 24.12.2022.
//

import Foundation
import CoreLocation
import RxSwift
import RxRelay

class CitiesService {
    
    var citiesSteam: Observable<City> { _citiesStream.asObservable() }
    
    private let _citiesStream = PublishRelay<City>()
    private let disposeBag = DisposeBag()
    
    private let remoteStorage = RemoteCitiesStorage()
    private let localStorage = LocalCitiesStorage()
    
    private lazy var fetchedCoordinates = localStorage.fetchedCoordinates
    
    init() {
        
        localStorage.citiesSteam.subscribe(onNext: { [weak self] city in
            
            self?._citiesStream.accept(city)
        }).disposed(by: disposeBag)
    }
    
    func startFetch() {
        
        localStorage.fetchCities()
    }
    
    func getCities(for location: CLLocationCoordinate2D) {
        
        guard isRemoteFetchNeeded(for: location) else {
            
            return
        }
        
        fetchedCoordinates.append(location)
        localStorage.save(coordinate: location)
        
        remoteStorage.fetch(latitude: location.latitude, longitude: location.longitude)
            .subscribe(onNext: { [weak self] cities in
                
                let cities = cities.filter({ [weak self] city in
                    
                    guard let self = self else { return false }
                    
                    return !self.fetchedCoordinates
                        .filter({ $0 != location })
                        .map({ CLLocation(coordinate: $0) })
                        .map({ $0.distance(from: .init(coordinate: city.location)) })
                        .contains(where: { $0 < 500000 })
                })
                
                self?.localStorage.save(cities: cities)
                
                cities.forEach({
                    
                    self?._citiesStream.accept($0)
                })
            })
            .disposed(by: disposeBag)
    }
    
    func localCities(for location: CLLocationCoordinate2D) -> [City] {
        
        localStorage.cities.filter({$0.location.distance(to: location) < 500000 })
    }
    
    private func isRemoteFetchNeeded(for location: CLLocationCoordinate2D) -> Bool {
        
        guard !fetchedCoordinates.isEmpty else { return true }
        
        return fetchedCoordinates.first(where: {
            
            $0.distance(to: location) < 250000
        }) == nil
    }
}
