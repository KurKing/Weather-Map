//
//  TodayWeatherCollectionViewCell.swift
//  Weather map
//
//  Created by Oleksii on 04.01.2023.
//

import UIKit

class TodayWeatherCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TodayWeatherCollectionViewCell"
    
    private let temperatureLabel: UILabel = {
       
        let label = withAutoloyaut(UILabel())
        
        label.textAlignment = .right
        label.font = .interRegular(size: 18)
        
        return label
    }()
    
    private let weatherIconImageView: UIImageView = {
        
        let imageView = withAutoloyaut(UIImageView(frame: .zero))
        
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    private let timeLabel: UILabel = {
       
        let label = withAutoloyaut(UILabel())
        
        label.textAlignment = .right
        label.font = .interRegular(size: 18)
        
        return label
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(temperatureLabel)
        contentView.addSubview(weatherIconImageView)
        contentView.addSubview(timeLabel)
        
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setup(with data: ShortWeatherData) {
        
        temperatureLabel.text = "\(data.temperature)ºC"
        weatherIconImageView.image = data.icon
        timeLabel.text = data.hour
    }
    
    private func addConstraints() {
        
        NSLayoutConstraint.activate([
            
            temperatureLabel.topAnchor.constraint(equalTo: contentView.topAnchor,
                                                  constant: 14),
            temperatureLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        
        weatherIconImageView.constraintSizeEqual(to: 35)
        NSLayoutConstraint.activate([
            
            weatherIconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            weatherIconImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            
            timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                              constant: -14),
            timeLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
}
