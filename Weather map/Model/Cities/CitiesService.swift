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
    
    private lazy var fetchedCoordinates = [CLLocationCoordinate2D]()
    
    init() {
        
        localStorage.citiesSteam.bind(to: _citiesStream)
            .disposed(by: disposeBag)
        
        localStorage.fetchCities()
    }
    
    func getCities(for location: CLLocationCoordinate2D) {
        
        guard isRemoteFetchNeeded(for: location) else {
            
            return
        }
        
        fetchedCoordinates.append(location)
        
        remoteStorage.fetch(latitude: location.latitude, longitude: location.longitude)
            .filter({ [weak self] city in
                
                guard let self = self else { return false }
                
                return !self.fetchedCoordinates
                    .filter({ $0 != location })
                    .map({ CLLocation(coordinate: $0) })
                    .map({ $0.distance(from: .init(coordinate: city.location)) })
                    .contains(where: { $0 < 500000 })
            })
            .subscribe(onNext: { [weak self] city in
                
                self?.localStorage.save(city: city)
                self?._citiesStream.accept(city)
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
