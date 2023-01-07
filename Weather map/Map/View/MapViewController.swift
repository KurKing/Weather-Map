//
//  MapViewController.swift
//  Weather map
//
//  Created by Oleksii on 18.12.2022.
//

import UIKit
import MapKit
import RxSwift
import RxCocoa
import RxRelay

enum MapConstants {
    
    static let defaultCameraZoomRange = MKMapView.CameraZoomRange(minCenterCoordinateDistance: 0,
                                                                  maxCenterCoordinateDistance: 500000)
}

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    private let viewModel: MapViewModelProtocol = MapViewModel()
    private let locationManager = LocationManager()
    private let router: Router = MapRouter()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupMapView()
        bindToViewModel()
        
        viewModel.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        locationManager.requestAuthorization { [weak self] location in
            
            self?.mapView.setCenter(location, animated: true)
        }
    }
    
    private func bindToViewModel() {
        
        viewModel.weatherPinCreationStream
            .subscribe(on: MainScheduler.instance)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] location in
                
                let pin = MKPointAnnotation()
                pin.coordinate = location
                
                self?.mapView.addAnnotation(pin)
            }).disposed(by: disposeBag)
    }
    
    private func setupMapView() {
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.setCameraZoomRange(MapConstants.defaultCameraZoomRange, animated: false)
        
        mapView.register(UserLocationView.self)
        mapView.register(WeatherPinView.self)
    }
}

// MARK: - MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            
            return mapView.dequeueReusableView(type: UserLocationView.self)
        }
        
        guard let weatherPinData = viewModel.data(for: annotation.coordinate) else {
            return nil
        }
        
        let weatherView = mapView.dequeueReusableView(type: WeatherPinView.self)
        
        weatherView.setup(temperature: weatherPinData.temperature,
                          weatherIcon: weatherPinData.icon)
        
        weatherView.onTap = { [weak self] location in
            
            guard let self = self else { return }
            
            self.router.route(to: .weatherDetails,
                              context: self,
                              parameter: self.viewModel.cityWeather(for: location))
        }
        
        return weatherView
    }
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        
        viewModel.mapCenter.accept(mapView.centerCoordinate)
    }
}
