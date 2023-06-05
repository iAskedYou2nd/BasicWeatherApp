//
//  LocartionManagerType.swift
//  BasicWeatherApp
//
//  Created by iAskedYou2nd on 5/31/23.
//

import Foundation
import Combine

protocol LocationManagerType {
    var currentLocationPublisher: PassthroughSubject<Coordinates, Never> { get }
    func requestLocation()
}
