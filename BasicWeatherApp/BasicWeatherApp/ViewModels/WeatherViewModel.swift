//
//  WeatherViewModel.swift
//  BasicWeatherApp
//
//  Created by iAskedYou2nd on 6/2/23.
//

import Foundation
import Combine

class DelayableSubject<Output, Failure>: Publisher where Failure: Error {
    
    private var subscriptions: [AnySubscriber<Output, Failure>] = []
    
    func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        let subscriber = AnySubscriber(subscriber)
        subscriptions.append(subscriber)
    }
    
    func sendWithDelay(of timeInterval: DispatchTimeInterval = DebugSettings.shared.animationDelayTimeThrottle, _ output: Output) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            for subscriber in self.subscriptions {
                _ = subscriber.receive(output)
            }
        }
    }

}

@propertyWrapper
class DelayablePublished<T> {
    
    typealias DelayedPublisher = PassthroughSubject<Result<T, Error>, Never>
    
    private let delayablePublisher = DelayedPublisher()
    private var internalValue: T?
    
    var wrappedValue: T? {
        get {
            return self.internalValue
        }
        set {
            self.internalValue = newValue
            DispatchQueue.global().asyncAfter(deadline: .now() + DebugSettings.shared.animationDelayTimeThrottle) {
                if let value = self.internalValue {
                    self.delayablePublisher.send(.success(value))
                } else {
                    self.delayablePublisher.send(.failure(NSError(domain: "Error", code: 0)))
                }
            }
        }
    }
    
    init(wrappedValue: T?) {
        self.wrappedValue = wrappedValue
    }
    
    var projectedValue: DelayedPublisher {
        return self.delayablePublisher
    }

}



class WeatherViewModel: ObservableObject, WeatherViewModelType {
    
    private let networkManager: NetworkManagerType
    private let locationManager: LocationManagerType?
    private let persistentContainer: PersistentContainerType
    private let cache: CacheType
    var weatherFormattedPublisher = PassthroughSubject<Result<WeatherFormatter, Error>, Never>()
//    var weatherFormattedPublisher = DelayableSubject<Result<WeatherFormatter, Error>, Never>()
    private var weatherModel: WeatherModel? {
        didSet {
            if self.weatherModel == nil {
                // MARK: Update this to be a custom Publisher object
                // Generic Error as there will always be the same message to the user
                DispatchQueue.global().asyncAfter(deadline: .now() + DebugSettings.shared.animationDelayTimeThrottle) {
                    self.weatherFormattedPublisher.send(.failure(NSError(domain: "Error", code: 0)))
                }
//                self.weatherFormattedPublisher.sendWithDelay(.failure(NSError(domain: "Error", code: 0)))
            }
        }
    }
    private var iconData: Data? {
        didSet {
            if let data = self.iconData, let weatherModel = self.weatherModel {
                let weatherFormatter = WeatherFormatter(weatherModel: weatherModel, iconData: data)
                // Only notify when all data is done
                DispatchQueue.global().asyncAfter(deadline: .now() + DebugSettings.shared.animationDelayTimeThrottle) {
                    self.weatherFormattedPublisher.send(.success(weatherFormatter))
                }
//                self.weatherFormattedPublisher.sendWithDelay(.success(weatherFormatter))
            } else {
                // Generic Error as there will always be the same message to the user
                DispatchQueue.global().asyncAfter(deadline: .now() + DebugSettings.shared.animationDelayTimeThrottle) {
                    self.weatherFormattedPublisher.send(.failure(NSError(domain: "Error", code: 0)))
                }
//                self.weatherFormattedPublisher.sendWithDelay(.failure(NSError(domain: "Error", code: 0)))
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
                self?.requestIconData(for: weatherModel.weather.first?.icon)
            }.store(in: &self.subscribers)
    }
    
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
