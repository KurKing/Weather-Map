//
//  WeatherForecastTableManager.swift
//  Weather map
//
//  Created by Oleksii on 03.01.2023.
//

import Foundation
import UIKit

class WeatherForecastTableManager: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    static let rowHeight: CGFloat = 40
    
    private let forecastItems: [ShortWeatherData]
    private weak var tableView: UITableView?
    
    init(viewModel: WeatherDetailsViewModelProtocol, tableView: UITableView) {
        
        self.forecastItems = viewModel.nextDaysForecast
        self.tableView = tableView
        
        super.init()
        
        tableView.register(WeatherForecastTableViewCell.self,
                           forCellReuseIdentifier: WeatherForecastTableViewCell.identifier)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func reloadData() {
        
        tableView?.reloadData()
    }
    
    func setupScroll(for height: CGFloat) {
        
        let contentHeight = WeatherForecastTableManager.rowHeight *  forecastItems.count.cgFloat
        
        tableView?.isScrollEnabled = contentHeight > height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return forecastItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier:
                                                        WeatherForecastTableViewCell.identifier)
                as? WeatherForecastTableViewCell else {
            
            return UITableViewCell()
        }
        
        cell.setup(with: forecastItems[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        WeatherForecastTableManager.rowHeight
    }
}
