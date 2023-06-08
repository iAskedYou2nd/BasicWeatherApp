//
//  WeatherFormatViewModel.swift
//  BasicWeatherApp
//
//  Created by iAskedYou2nd on 6/7/23.
//

import Foundation

struct WeatherFormatter {
    
    private let weatherModel: WeatherModel
    let iconData: Data
    
    init(weatherModel: WeatherModel, iconData: Data) {
        self.weatherModel = weatherModel
        self.iconData = iconData
    }
    
    var locationName: String {
        return self.weatherModel.name
    }
    
    var temperature: String {
        return "\(self.weatherModel.main.temp)°"
    }
    
    var minMaxFeelsLike: String {
        return "\(self.weatherModel.main.tempMin)° / \(self.weatherModel.main.tempMax)° Feels like \(self.weatherModel.main.feelsLike)°"
    }
    
    var iconDescription: String {
        return self.weatherModel.weather.first?.description ?? "N/A"
    }
    
    var pressure: String {
        return "Pressure: \(self.weatherModel.main.pressure)hPa"
    }
    
    var humidity: String {
        return "Humidity: \(self.weatherModel.main.humidity)%"
    }
    
    var windSpeed: String {
        return "Wind Speed: \(self.weatherModel.wind.speed)mph"
    }
    
    var cloudCoverage: String {
        return "Cloud Coverage: \(self.weatherModel.clouds.all)%"
    }
    
}
