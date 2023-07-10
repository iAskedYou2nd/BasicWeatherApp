//
//  MockLocationService.swift
//  BasicWeatherAppTests
//
//  Created by iAskedYou2nd on 7/11/23.
//

import Foundation
import CoreLocation
@testable import BasicWeatherApp

class MockLocationService: CLLocationManager {
    
    let shouldSucceed: Bool
    
    init(shouldSucceed: Bool) {
        self.shouldSucceed = shouldSucceed
    }
    
    override func requestLocation() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            if self.shouldSucceed {
                let location = CLLocation(latitude: 37.3323, longitude: -122.0312)
                self.delegate?.locationManager?(self, didUpdateLocations: [location])
            } else {
                self.delegate?.locationManager?(self, didFailWithError: NSError(domain: "1", code: 1))
            }
        }
    }
    
}
