//
//  MapRouter.swift
//  Weather map
//
//  Created by Oleksii on 26.12.2022.
//

import UIKit

class MapRouter: Router {
    
    func route(to route: Route, context: UIViewController, parameter: Any?) {
        
        guard route == .weatherDetails else {
            
            fatalError("MapRouter error: Unknown route")
        }
        
        guard let weatherData = parameter as? CityWeatherModel,
              let viewModel = WeatherDetailsViewModel(cityWeather: weatherData) else {
            
            return
        }
        
        WeatherAnalytics().logOpenCityDetailsEvent(city: viewModel.city)
        
        context.present(WeatherDetailsViewController.initiate(viewModel: viewModel),
                        animated: true)
    }
}
