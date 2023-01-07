//
//  WeatherDetailsRouter.swift
//  Weather map
//
//  Created by Oleksii on 02.01.2023.
//

import Foundation
import UIKit

class WeatherDetailsRouter: Router {
    
    func route(to route: Route, context: UIViewController, parameter: Any?) {
        
        if route == .back {
            
            context.dismiss(animated: true)
            return
        }
        
        if route == .banner {
            
            if let url = URL(string: "https://savelife.in.ua/en/") {
                
                UIApplication.shared.open(url)
            }
            
            return
        }
        
        fatalError("MapRouter error: Unknown route")
    }
}
