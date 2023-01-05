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
    
    @IBOutlet weak var todayWeatherHeightConstraint: NSLayoutConstraint!
    fileprivate var todayWeatherViewHeight: CGFloat {
        
        todayWeatherHeightConstraint.constant
    }
    
    fileprivate var viewModel: WeatherDetailsViewModelProtocol!
    fileprivate var router: Router!
    
    fileprivate var forecastTableViewManager: WeatherForecastTableManager!
    fileprivate var todayWeatherCollectionViewManager: TodayWeatherCollectionViewManager!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupSubviews()
        setData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        forecastTableViewManager.setupScroll(for: forecastView.bounds.height)
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
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = .zero
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        let collectionView = withAutoloyaut(UICollectionView(frame: .zero,
                                                             collectionViewLayout: layout))
        collectionView.isScrollEnabled = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.allowsSelection = false
        
        todayWeatherView.addSubview(collectionView)
        collectionView.pinToSuperview()
        
        todayWeatherCollectionViewManager = .init(items: viewModel.todayWeatherForecast,
                                                  rowHeight: todayWeatherViewHeight,
                                                  collectionView: collectionView)
        
        // Forecast table
        let tableView = withAutoloyaut(UITableView(frame: .zero))
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.isScrollEnabled = false
        
        forecastView.addSubview(tableView)
        tableView.pinToSuperview()
        
        forecastTableViewManager = .init(forecastItems: viewModel.nextDaysForecast,
                                         tableView: tableView)
    }
    
    func setData() {
        
        temperatureLabel.text = viewModel.temperature
        cityNameLabel.text = viewModel.city
        humidityLabel.text = viewModel.humidity
        windSpeedLabel.text = viewModel.windSpeed
        
        todayDateLabel.text = viewModel.todayDate
    }
}
