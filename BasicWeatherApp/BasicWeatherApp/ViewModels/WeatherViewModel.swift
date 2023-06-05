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
    // MARK: Consider either 2 pubs for icon and data, or have logic to only send when both are available
    var weatherDataPublisher: PassthroughSubject<WeatherModel, Never> = PassthroughSubject()
    private var weatherModel: WeatherModel? {
        didSet {
            guard let model = self.weatherModel else { return }
            self.weatherDataPublisher.send(model)
        }
    }
    // TODO: Replace to the detail viewmodel
    var weatherIconDataPublisher: PassthroughSubject<Data, Never> = PassthroughSubject()
    private var iconData: Data? {
        didSet {
            guard let data = self.iconData else { return }
            self.weatherIconDataPublisher.send(data)
        }
    }
    private var subscribers = Set<AnyCancellable>()
    
    init(networkManager: NetworkManagerType = NetworkManager(), locationManager: LocationManagerType = LocationManager(), persistentContainer: PersistentContainerType = UserDefaultsModelWrapper(), cache: CacheType = ImageCache.shared) {
        self.networkManager = networkManager
        self.locationManager = locationManager
        self.persistentContainer = persistentContainer
        self.cache = cache
    }
    
    func loadMostRecentLocation() {
        guard let mostRecentCoord = self.persistentContainer.getModel(type: Coordinates.self) else { return }
        let request = Environment.weatherCoordinates(mostRecentCoord.lat, mostRecentCoord.lon).request
        self.requestNetwork(request: request)
    }
    
    func loadCurrentLocationWeather() {
        // TODO: Update when Location Errors are made
        self.locationManager?.currentLocationPublisher
            .sink(receiveValue: { [weak self] coords in
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
            .sink { completion in
                // TODO: Error Handle
                print(completion)
            } receiveValue: { [weak self] (weatherModel: WeatherModel) in
                self?.weatherModel = weatherModel
                self?.persistentContainer.setModel(model: weatherModel.coord)
                self?.requestIconData(for: weatherModel.weather.first?.icon)
            }.store(in: &self.subscribers)
    }
    
    // TODO: Place this in weatherDetailViewmodel
    private func requestIconData(for iconName: String?) {
        guard let iconName = iconName else { return }
        
        if let cachedData = self.cache.get(for: iconName) {
            self.iconData = cachedData
            print("Cached Icon")
            return
        }
        
        let request = Environment.weatherIcon(iconName).request
        self.networkManager.fetchData(request: request)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                print(completion)
            } receiveValue: { [weak self] iconData in
                self?.iconData = iconData
                self?.cache.set(iconData, for: iconName)
                print("Fetched Icon")
            }.store(in: &self.subscribers)

    }
    
}