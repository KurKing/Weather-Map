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
    
    static let defaultCameraZoomRange = MKMapView.CameraZoomRange(minCenterCoordinateDistance: 500000,
                                                                  maxCenterCoordinateDistance: 500000)
}

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    private let viewModel: MapViewModelProtocol = MapViewModel()
    private let disposeBag = DisposeBag()
    
    private let locationManager = LocationManager()
        
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupMapView()
        bindToViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        locationManager.requestAuthorization { [weak self] location in
            
            self?.mapView.setCenter(location, animated: true)
        }
    }
    
    private func bindToViewModel() {
        
        viewModel.weatherPinCreationStream.subscribe(onNext: { [weak self] location in
            
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
        
        return weatherView
    }
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        
        viewModel.mapCenter.accept(mapView.centerCoordinate)
    }
}
