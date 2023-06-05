//
//  Environment.swift
//  BasicWeatherApp
//
//  Created by iAskedYou2nd on 5/31/23.
//

import Foundation

enum Environment {
    
    private struct API {
        static let key = "27223ecc8b48060bb0826dacc16e5465"
        static let domain = "https://api.openweathermap.org/"
        static let weatherPath = "data/2.5/weather"
        static let weatherIconPath = "img/wn/"
    }
    
    private struct Keys {
        static let appid = "appid"
        static let lat = "lat"
        static let long = "lon"
        static let city = "city"
        static let stringQueries = "q"
        static let units = "units"
    }
    
    private struct HTTPMethods {
        static let get = "GET"
        static let post = "POST"
    }
    
    case weatherCoordinates(_ lat: Double, _ long: Double)
    case weatherSearchQuery(_ query: String)
    case weatherIcon(_ iconName: String)
    
    var request: URLRequest? {

        switch self {
        case .weatherCoordinates(let lat, let long):
            let queryables = [URLQueryItem(name: Keys.lat, value: String(lat)),
                              URLQueryItem(name: Keys.long, value: String(long))]
            
            let components = generateWeatherBaseComponents(queryables: queryables)
            
            guard let url = components?.url else { return nil }
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethods.get
            return request
            
        case .weatherSearchQuery(let query):
            let queryables = [URLQueryItem(name: Keys.stringQueries, value: query)]
            let components = generateWeatherBaseComponents(queryables: queryables)
            
            guard let url = components?.url else { return nil }
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethods.get
            return request
            
        case .weatherIcon(let iconName):
            // TODO: Revisit the replacing occurences approach
            guard let url = URL(string: API.domain.replacingOccurrences(of: "api.", with: "") + API.weatherIconPath + iconName + "@2x.png") else { return nil }
            return URLRequest(url: url)
        }
    }
    
    private func generateWeatherBaseComponents(queryables: [URLQueryItem]) -> URLComponents? {
        var components = URLComponents(string: API.domain + API.weatherPath)
        components?.queryItems = queryables
        components?.queryItems?.append(URLQueryItem(name: Keys.appid, value: API.key))
        components?.queryItems?.append(URLQueryItem(name: Keys.units, value: "imperial"))
        return components
    }
                              
    
}
