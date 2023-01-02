//
//  WeatherDetailsViewModel.swift
//  Weather map
//
//  Created by Oleksii on 02.01.2023.
//

import Foundation
import RxSwift
import RxRelay

protocol WeatherDetailsViewModelProtocol {
    
    var isComeBackAliveBannerHidden: BehaviorRelay<Bool> { get }
    
    var city: String { get }
    var temperature: String { get }
    var humidity: String { get }
    var windSpeed: String { get }
    
    var todayDate: String { get }
    
    var todayWeatherForecast: [ShortWeatherData] { get }
    var nextDaysForecast: [ShortWeatherData] { get }
}

class WeatherDetailsViewModel: WeatherDetailsViewModelProtocol {
    
    var isComeBackAliveBannerHidden = BehaviorRelay<Bool>(value: true)
    
    var city: String { cityWeather.city.name.uppercased() }
    var temperature: String { "\(cityWeather.weatherList.first!.temperature)°" }
    var humidity: String { "\(cityWeather.weatherList.first!.humidity)%" }
    var windSpeed: String { "\(cityWeather.weatherList.first!.windSpeed) m/s" }
    var todayDate: String { "Feb, 24" }
    
    var todayWeatherForecast: [ShortWeatherData] { [] }
    var nextDaysForecast: [ShortWeatherData] { [] }
    
    private let cityWeather: CityWeatherModel
    
    init?(cityWeather: CityWeatherModel) {
        
        if cityWeather.weatherList.isEmpty { return nil }
        
        self.cityWeather = cityWeather
    }
}
