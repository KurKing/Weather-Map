//
//  UserLocationView.swift
//  Weather map
//
//  Created by Oleksii on 18.12.2022.
//

import UIKit
import MapKit

class UserLocationView: MKAnnotationView {
    
    private let locationImageView: UIImageView = {
        
        let imageView = withAutoloyaut(UIImageView(image: .location))
        
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        frame = .init(x: 0, y: 0, width: 30, height: 30)
        centerOffset = .init(x: 0, y: -frame.size.height / 2)
        
        canShowCallout = false
        
        addSubview(locationImageView)
        
        locationImageView.pinToSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
