//
//  WeatherViewModel.swift
//  BasicWeatherApp
//
//  Created by iAskedYou2nd on 6/2/23.
//

import Foundation
import Combine

class WeatherViewModel: ObservableObject, WeatherViewModelType {
    
    private let networkManager: NetworkManagerType
    private let locationManager: LocationManagerType?
    private let persistentContainer: PersistentContainerType
    private let cache: CacheType
    var weatherFormattedPublisher = PassthroughSubject<Result<WeatherFormatter, Error>, Never>()
    private var weatherModel: WeatherModel? {
        didSet {
            if self.weatherModel == nil {
                // Generic Error as there will always be the same message to the user
                self.weatherFormattedPublisher.send(.failure(NSError(domain: "Error", code: 0)))
            }
        }
    }
    private var iconData: Data? {
        didSet {
            if let data = self.iconData, let weatherModel = self.weatherModel {
                let weatherFormatter = WeatherFormatter(weatherModel: weatherModel, iconData: data)
                // Only notify when all data is done
                self.weatherFormattedPublisher.send(.success(weatherFormatter))
            } else {
                // Generic Error as there will always be the same message to the user
                self.weatherFormattedPublisher.send(.failure(NSError(domain: "Error", code: 0)))
            }
        }
    }
    private var subscribers = Set<AnyCancellable>()
    
    init(networkManager: NetworkManagerType = NetworkManager(), locationManager: LocationManagerType = LocationManager(), persistentContainer: PersistentContainerType = UserDefaultsModelWrapper(), cache: CacheType = ImageCache.shared) {
        self.networkManager = networkManager
        self.locationManager = locationManager
        self.persistentContainer = persistentContainer
        self.cache = cache
    }
    
    func loadMostRecentLocation(completion: () -> Void) {
        guard let mostRecentCoord = self.persistentContainer.getModel(type: Coordinates.self) else { return }
        let request = Environment.weatherCoordinates(mostRecentCoord.lat, mostRecentCoord.lon).request
        self.requestNetwork(request: request)
        completion()
    }
    
    func loadCurrentLocationWeather() {
        self.locationManager?.currentLocationPublisher
            .sink(receiveCompletion: { [weak self] completion in
                self?.weatherModel = nil
            }, receiveValue: { [weak self] coords in
                let request = Environment.weatherCoordinates(coords.lat, coords.lon).request
                self?.requestNetwork(request: request)
            }).store(in: &self.subscribers)
        self.locationManager?.requestLocation()
    }
    
    func loadQueriedLocationWeather(query: String) {
        let sanitizedQuery = QuerySanitizer.sanitizeWeatherQuery(for: query)
        let request = Environment.weatherSearchQuery(sanitizedQuery).request
        self.requestNetwork(request: request)
    }
        
    private func requestNetwork(request: URLRequest?) {
        self.networkManager.fetchModel(request: request)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure = completion {
                    self?.weatherModel = nil
                }
                print(completion)
            } receiveValue: { [weak self] (weatherModel: WeatherModel) in
                self?.weatherModel = weatherModel
                self?.persistentContainer.setModel(model: weatherModel.coord)
                self?.requestIconDataFromCache(for: weatherModel.weather.first?.icon)
            }.store(in: &self.subscribers)
    }
    
    private func requestIconDataFromCache(for iconName: String?) {
        guard let iconName = iconName else { return }
        
        self.cache.get(for: iconName)
            .sink { [weak self] data in
                if let data = data {
                    print("Cached Icon")
                    self?.iconData = data
                } else {
                    self?.requestIconDataFromNetwork(for: iconName)
                }
            }.store(in: &self.subscribers)
    }
    
    private func requestIconDataFromNetwork(for iconName: String) {
        let request = Environment.weatherIcon(iconName).request
        self.networkManager.fetchData(request: request)
            .sink { [weak self] completion in
                if case .failure = completion {
                    self?.iconData = nil
                }
                print(completion)
            } receiveValue: { [weak self] iconData in
                self?.iconData = iconData
                self?.cache.set(iconData, for: iconName)
                print("Fetched Icon")
            }.store(in: &self.subscribers)
    }
    
}
