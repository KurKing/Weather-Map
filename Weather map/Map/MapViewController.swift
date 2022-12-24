//
//  MapViewController.swift
//  Weather map
//
//  Created by Oleksii on 18.12.2022.
//

import UIKit
import MapKit

enum MapConstants {
    
    static let defaultCameraZoomRange = MKMapView.CameraZoomRange(minCenterCoordinateDistance: 500000,
                                                                  maxCenterCoordinateDistance: 500000)
}

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    private lazy var lastpinCenter: CLLocationCoordinate2D = mapView.centerCoordinate
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupMapView()
        locationManager.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func setupMapView() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.setCameraZoomRange(MapConstants.defaultCameraZoomRange, animated: true)
        
        mapView.register(UserLocationView.self)
        mapView.register(WeatherPinView.self)
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            
            return mapView.dequeueReusableView(type: UserLocationView.self)
        }
        
        return with(mapView.dequeueReusableView(type: WeatherPinView.self)) {
            $0.setup(temperature: 27, weatherIcon: .sunWithCloudsWeatherIcon)
        }
    }
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        
        if lastpinCenter.distance(to: mapView.centerCoordinate) > 1 {
            
            self.lastpinCenter = mapView.centerCoordinate
            
            let pin = MKPointAnnotation.pinInCenter(of: mapView)
            
            Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
                
                mapView.removeAnnotation(pin)
            }
            
            mapView.addAnnotation(pin)
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    
        if let location = manager.location {
            
            mapView.setCenter(location.coordinate, animated: true)
        }
    }
}
