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
    
    private let manager: CLLocationManager
    
    // TODO: Check for location errors possible and replace with Never
    var currentLocationPublisher = PassthroughSubject<Coordinates, Error>()
    private var currentLocation: Coordinates? {
        didSet {
            if let location = self.currentLocation {
                self.currentLocationPublisher.send(location)
            } else {
                self.currentLocationPublisher.send(completion: .failure(NSError(domain: "Error", code: 0)))
            }
        }
    }
    
    init(manager: CLLocationManager = CLLocationManager()) {
        self.manager = manager
        super.init()
        self.manager.delegate = self
        self.manager.requestAlwaysAuthorization()
        self.manager.requestWhenInUseAuthorization()
    }
    
    func requestLocation() {
        self.manager.requestLocation()
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse {
            self.manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let clCoordinates = locations.first?.coordinate else { return }
        self.currentLocation = Coordinates(lon: clCoordinates.longitude, lat: clCoordinates.latitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Error: \(error)")
        self.currentLocation = nil
    }
    
    
}


