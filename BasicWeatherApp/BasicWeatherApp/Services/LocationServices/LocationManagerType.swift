//
//  LocartionManagerType.swift
//  BasicWeatherApp
//
//  Created by iAskedYou2nd on 5/31/23.
//

import Foundation
import Combine

protocol LocationManagerType {
    var currentLocationPublisher: PassthroughSubject<Coordinates, Error> { get }
    func requestLocation()
}
