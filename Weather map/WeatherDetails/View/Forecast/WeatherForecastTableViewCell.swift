//
//  WeatherForecastTableViewCell.swift
//  Weather map
//
//  Created by Oleksii on 03.01.2023.
//

import UIKit

class WeatherForecastTableViewCell: UITableViewCell {
    
    static let identifier = "WeatherForecastTableViewCell"
    
    private let dayLabel: UILabel = {
       
        let label = withAutoloyaut(UILabel())
        
        label.textAlignment = .left
        label.font = .interMedium(size: 18)
        
        return label
    }()
    
    private let weatherIconImageView: UIImageView = {
        
        let imageView = withAutoloyaut(UIImageView(frame: .zero))
        
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    private let temperatureLabel: UILabel = {
       
        let label = withAutoloyaut(UILabel())
        
        label.textAlignment = .right
        label.font = .interRegular(size: 18)
        
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(dayLabel)
        contentView.addSubview(weatherIconImageView)
        contentView.addSubview(temperatureLabel)
        
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(with data: ShortWeatherData) {
        
        dayLabel.text = data.weekDay
        weatherIconImageView.image = data.icon
        temperatureLabel.text = "\(data.temperature)ºC"
    }

    private func addConstraints() {
        
        NSLayoutConstraint.activate([
            
            dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            dayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        weatherIconImageView.constraintSizeEqual(to: 24)
        NSLayoutConstraint.activate([
            
            weatherIconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                          constant: 130),
            weatherIconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            
            temperatureLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            temperatureLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
