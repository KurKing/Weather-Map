//
//  With.swift
//  Weather map
//
//  Created by Oleksii on 18.12.2022.
//

import Foundation
import UIKit

func with<T>(_ obj: T, completion: @escaping(T)->()) -> T {
    
    completion(obj)
    return obj
}

func withAutoloyaut<T: UIView>(_ view: T) -> T {
    
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
}
