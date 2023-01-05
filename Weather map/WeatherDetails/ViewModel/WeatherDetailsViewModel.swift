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
    
    var todayDate: String {
        
        todayDateFormatter.string(from: cityWeather.weatherList.first!.date)
    }
    
    lazy var todayWeatherForecast: [ShortWeatherData] = {
        
        var itemsCount = cityWeather.weatherList.count > 4 ? 4 : cityWeather.weatherList.count

        return cityWeather.weatherList[0..<itemsCount].map({ .init(weatherItem: $0) })
    }()
    
    lazy var nextDaysForecast: [ShortWeatherData] = {
        
        forecastFilter(items: cityWeather.weatherList, by: 12)
            .map({ .init(weatherItem: $0) })
    }()
    
    private let cityWeather: CityWeatherModel
    
    private let todayDateFormatter = with(DateFormatter()) {
        
        $0.dateFormat = "MMM, d"
        $0.locale = .init(identifier: "en_US")
    }
    private let forecastDateFormatter = with(DateFormatter()) {
        
        $0.dateFormat = "HH"
        $0.timeZone = TimeZone(abbreviation: "UTC")
        $0.locale = .init(identifier: "en_US")
    }
    
    init?(cityWeather: CityWeatherModel) {
        
        if cityWeather.weatherList.isEmpty { return nil }
        
        self.cityWeather = cityWeather
    }

    private func forecastFilter(items: [WeatherItem], by hour: Int) -> [WeatherItem] {
        
        return items.filter({
            
            if Calendar.current.isDateInToday($0.date) {
                
                return false
            }
            
            let dateHour = forecastDateFormatter.string(from: $0.date)
            
            return dateHour == "\(hour)"
        })
    }
}
