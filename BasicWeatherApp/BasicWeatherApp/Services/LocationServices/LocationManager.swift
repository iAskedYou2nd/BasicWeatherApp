//
//  LocationManager.swift
//  BasicWeatherApp
//
//  Created by iAskedYou2nd on 5/31/23.
//

import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, LocationManagerType {
    
    private let manager: CLLocationManager = CLLocationManager()
    
    // TODO: Check for location errors possible and replace with Never
    var currentLocationPublisher: PassthroughSubject<Coordinates, Never> = PassthroughSubject()
    private var currentLocation: Coordinates? {
        didSet {
            guard let location = self.currentLocation else { return }
            self.currentLocationPublisher.send(location)
        }
    }
    
    override init() {
        super.init()
        self.manager.delegate = self
        self.manager.requestAlwaysAuthorization()
        self.manager.requestWhenInUseAuthorization()
    }
    
//    convenience init(initialLocation: Coordinates) {
//        self.init()
//        self.currentLocation = initialLocation
//    }
    
    func requestLocation() {
        self.manager.requestLocation()
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("Auth Updated!")
        if manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse {
            self.manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let clCoordinates = locations.first?.coordinate else { return }
        self.currentLocation = Coordinates(lon: clCoordinates.longitude, lat: clCoordinates.latitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error)")
    }
    
    
}


