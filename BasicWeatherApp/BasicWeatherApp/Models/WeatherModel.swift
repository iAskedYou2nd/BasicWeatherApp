//
//  WeatherModel.swift
//  BasicWeatherApp
//
//  Created by iAskedYou2nd on 5/31/23.
//

import Foundation

struct WeatherModel: Decodable {
    let coord: Coordinates
    let weather: [Weather]
    let base: String
    let main: MainValues
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Int64
    let sys: SystemInfo
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
}

// Only Model Codable as it needs both Decodable and Encodable
struct Coordinates: Codable {
    let lon: Double
    let lat: Double
}

struct Weather: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct MainValues: Decodable {
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let pressure: Int
    let humidity: Int
    let seaLevel: Int?
    let grndLevel: Int?
}

struct Wind: Decodable {
    let speed: Double
    let deg: Double
    let gust: Double?
}

struct Clouds: Decodable {
    let all: Int
}

struct SystemInfo: Decodable {
    let type: Int?
    let id: Int?
    let country: String
    let sunrise: Int64
    let sunset: Int64
}
