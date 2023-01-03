//
//  Fonts.swift
//  Weather map
//
//  Created by Oleksii on 03.01.2023.
//

import Foundation
import UIKit

extension UIFont {
    
    static func interBold(size: CGFloat) -> UIFont {
        
        .init(name: "Inter-Bold", size: size) ?? .systemFont(ofSize: size, weight: .bold)
    }
    
    static func interMedium(size: CGFloat) -> UIFont {
        
        .init(name: "Inter-Medium", size: size) ?? .systemFont(ofSize: size, weight: .medium)
    }
    
    static func interRegular(size: CGFloat) -> UIFont {
        
        .init(name: "Inter-Regular", size: size) ?? .systemFont(ofSize: size, weight: .regular)
    }
}
