//
//  UIView + Constraints.swift
//  Weather map
//
//  Created by Oleksii on 18.12.2022.
//

import UIKit

extension UIView {
    
    func constraintSizeEqual(to constant: CGFloat) {
        
        NSLayoutConstraint.activate([
            
            widthAnchor.constraint(equalToConstant: constant),
            heightAnchor.constraint(equalToConstant: constant)
        ])
    }
    
    func pinToSuperview() {
        
        guard let superview = superview else { return }
        
        NSLayoutConstraint.activate([
            
            topAnchor.constraint(equalTo: superview.topAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor)
        ])
    }
}
