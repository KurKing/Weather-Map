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
        
        // TODO: - present weather details view controller
        print("TODO print - route to weather details")
    }
}
