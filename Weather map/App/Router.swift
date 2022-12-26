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
}

protocol Router {

    func route(to route: Route, context: UIViewController, parameter: Any?)
}
