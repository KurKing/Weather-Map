//
//  RemoteCitiesStorage.swift
//  Weather map
//
//  Created by Oleksii on 24.12.2022.
//

import Foundation
import Alamofire
import RxSwift
import SwiftyJSON

class RemoteCitiesStorage {
    
    private let headers: HTTPHeaders = [
        "X-RapidAPI-Key": Keys.cityApiKey,
        "X-RapidAPI-Host": "world-geo-data.p.rapidapi.com"
    ]
    
    private let baseUrl = URL(string: "https://world-geo-data.p.rapidapi.com/cities/nearby")!
    
    func fetch(latitude: Double, longitude: Double, minimumCityPopulation: Int = 50000) -> Observable<[City]> {
        
        let parameters: [String: Any] = [
            "latitude": latitude,
            "longitude": longitude,
            "radius": 500,
            "min_population": minimumCityPopulation
        ]
        
        return Observable.create { [weak self] observer in
            
            guard let self = self else {
                
                observer.onCompleted()
                return Disposables.create()
            }
            
            AF.request(self.baseUrl,
                       method: .get,
                       parameters: parameters,
                       headers: self.headers)
            .validate(statusCode: 200..<300)
            .responseData { response in
                
                if let data = response.data, let jsonData = try? JSON(data: data),
                   let cities = jsonData["cities"].array {
                    
                    observer.onNext(cities.compactMap({ City(json: $0) }))
                }
                
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
}
