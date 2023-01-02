//
//  WeatherDetailsViewController.swift
//  Weather map
//
//  Created by Oleksii on 02.01.2023.
//

import UIKit

extension WeatherDetailsViewController {
    
    class func initiate(viewModel: WeatherDetailsViewModelProtocol) -> WeatherDetailsViewController {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "WeatherDetailsViewController") as! WeatherDetailsViewController
        
        viewController.viewModel = viewModel
        viewController.router = WeatherDetailsRouter()
        
        return viewController
    }
}

class WeatherDetailsViewController: UIViewController {
    
    @IBOutlet weak var closeButton: UIImageView!
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    
    @IBOutlet weak var todayWeatherDetailsView: UIView!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    
    fileprivate var viewModel: WeatherDetailsViewModelProtocol!
    fileprivate var router: Router!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        todayWeatherDetailsView.layer.cornerRadius =  20
        
        closeButton.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(onCloseButtonTapped)))
        
        bannerImage.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(onBannerTapped)))
        
        temperatureLabel.text = viewModel.temperature
        cityNameLabel.text = viewModel.city
        humidityLabel.text = viewModel.humidity
        windSpeedLabel.text = viewModel.windSpeed
    }
    
    @objc private func onCloseButtonTapped() {
        
        router.route(to: .back, context: self)
    }
    
    @objc private func onBannerTapped() {
        
        router.route(to: .banner, context: self)
    }
}
