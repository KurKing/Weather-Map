//
//  WeatherPinView.swift
//  Weather map
//
//  Created by Oleksii on 24.12.2022.
//

import UIKit
import MapKit

class WeatherPinView: MKAnnotationView {
    
    var onTap: ((CLLocationCoordinate2D)->())?
    
    private let pinImageView: UIImageView = {
        
        let imageView = withAutoloyaut(UIImageView(image: .mapPin))
        
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let temperatureLabel: UILabel = {
        
        let label = withAutoloyaut(UILabel())
        
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .bold)
        
        return label
    }()
    
    private let weatherImageView: UIImageView = {
        
        let imageView = withAutoloyaut(UIImageView(image: .sunWithCloudsWeatherIcon))
        
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        frame = .init(x: 0, y: 0, width: 50, height: 65)
        centerOffset = .init(x: 0, y: -frame.size.height / 2)
        
        canShowCallout = false
        
        addSubview(pinImageView)
        pinImageView.addSubview(temperatureLabel)
        pinImageView.addSubview(weatherImageView)
        
        setupConstraints()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(pinTapped))
        addGestureRecognizer(gestureRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(temperature: Int, weatherIcon: UIImage) {
        
        temperatureLabel.text = "\(temperature)°"
        weatherImageView.image = weatherIcon
    }
    
    private func setupConstraints() {
        
        pinImageView.pinToSuperview()
        
        temperatureLabel.constraintSizeEqual(to: 24)
        
        NSLayoutConstraint.activate([
            
            temperatureLabel.topAnchor.constraint(equalTo: pinImageView.topAnchor,
                                                  constant: 4),
            temperatureLabel.centerXAnchor.constraint(equalTo: pinImageView.centerXAnchor)
        ])
        
        weatherImageView.constraintSizeEqual(to: 18)
        
        NSLayoutConstraint.activate([
            
            weatherImageView.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor,
                                                  constant: -2),
            weatherImageView.centerXAnchor.constraint(equalTo: pinImageView.centerXAnchor)
        ])
    }
    
    @objc private func pinTapped() {
        
        if let onTap = onTap, let coordinate = annotation?.coordinate {
            
            onTap(coordinate)
        }
    }
}
