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
    
    @IBOutlet weak var todayDateLabel: UILabel!
    
    @IBOutlet weak var todayWeatherView: UIView!
    @IBOutlet weak var forecastView: UIView!
    
    fileprivate var viewModel: WeatherDetailsViewModelProtocol!
    fileprivate var router: Router!
    
    fileprivate var forecastTableViewManager: WeatherForecastTableManager!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupSubviews()
        setData()
    }
    
    @objc private func onCloseButtonTapped() {
        
        router.route(to: .back, context: self)
    }
    
    @objc private func onBannerTapped() {
        
        router.route(to: .banner, context: self)
    }
}

// MARK: - Subviews
private extension WeatherDetailsViewController {
    
    func setupSubviews() {
        
        todayWeatherDetailsView.layer.cornerRadius =  20
        
        closeButton.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(onCloseButtonTapped)))
        
        bannerImage.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(onBannerTapped)))
        
        // Today weather collection view
        
        // Forecast table
        let tableView = withAutoloyaut(UITableView(frame: .zero))
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        
        forecastView.addSubview(tableView)
        tableView.pinToSuperview()
        
        forecastTableViewManager = WeatherForecastTableManager(viewModel: viewModel,
                                                               tableView: tableView)
        
        forecastTableViewManager.setupScroll(for: forecastView.bounds.height)
    }
    
    func setData() {
        
        temperatureLabel.text = viewModel.temperature
        cityNameLabel.text = viewModel.city
        humidityLabel.text = viewModel.humidity
        windSpeedLabel.text = viewModel.windSpeed
        
        todayDateLabel.text = viewModel.todayDate
    }
}
