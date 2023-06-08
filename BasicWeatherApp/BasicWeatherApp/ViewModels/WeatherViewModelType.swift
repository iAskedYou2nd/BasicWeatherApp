//
//  WeatherViewModelType.swift
//  BasicWeatherApp
//
//  Created by iAskedYou2nd on 6/2/23.
//

import Foundation
import Combine

protocol WeatherViewModelType {
    var weatherFormattedPublisher: PassthroughSubject<WeatherFormatter, Error> { get }
    func loadMostRecentLocation(completion: () -> Void)
    func loadCurrentLocationWeather()
    func loadQueriedLocationWeather(query: String)
}
