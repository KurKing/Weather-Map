//
//  Router.swift
//  Weather map
//
//  Created by Oleksii on 26.12.2022.
//

import Foundation
import UIKit

enum Route {
    
    case back
    case weatherDetails
    case banner
}

protocol Router {

    func route(to route: Route, context: UIViewController, parameter: Any?)
}

extension Router {
    
    func route(to route: Route, context: UIViewController) {
        
        self.route(to: route, context: context, parameter: nil)
    }
}
