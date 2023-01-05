//
//  RemoteWeatherStorage.swift
//  Weather map
//
//  Created by Oleksii on 24.12.2022.
//

import Foundation
import Alamofire
import RxSwift
import SwiftyJSON

class RemoteWeatherStorage {
    
    private let baseUrl = URL(string: "https://api.openweathermap.org/data/2.5/forecast")!
    
    func fetch(latitude: Double, longitude: Double) -> Observable<[WeatherItem]> {
        
        let parameters: [String: Any] = [
            "lat": latitude,
            "lon": longitude,
            "appid": Keys.weatherApiKey,
            "units": "metric"
        ]
        
        return Observable.create { [weak self] observer in
            
            guard let self = self else {
                
                observer.onCompleted()
                return Disposables.create()
            }
            
            AF.request(self.baseUrl,
                       method: .get,
                       parameters: parameters)
            .validate(statusCode: 200..<300)
            .responseData { response in
                
                if let data = response.data, let jsonData = try? JSON(data: data),
                   let weather = jsonData["list"].array {

                    observer.onNext(weather.compactMap({ WeatherItem(json: $0) }))
                }
                
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
}
