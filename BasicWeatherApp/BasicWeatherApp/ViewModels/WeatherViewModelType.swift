//
//  WeatherViewModelType.swift
//  BasicWeatherApp
//
//  Created by iAskedYou2nd on 6/2/23.
//

import Foundation
import Combine

protocol WeatherViewModelType {
    var weatherDataPublisher: PassthroughSubject<WeatherModel, Never> { get }
    // TODO: Move to detail view model
    var weatherIconDataPublisher: PassthroughSubject<Data, Never> { get }
    func loadMostRecentLocation()
    func loadCurrentLocationWeather()
    func loadQueriedLocationWeather(query: String)
}
