//
//  NetworkManager.swift
//  BasicWeatherApp
//
//  Created by iAskedYou2nd on 5/31/23.
//

import Foundation
import Combine

class NetworkManager {
    
    let session: PublisherSession
    let decoder: JSONDecoder
    
    init(session: PublisherSession = URLSession.shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.decoder = decoder
    }
    
}

extension NetworkManager: NetworkManagerType {
    
    func fetchModel<T: Decodable>(request: URLRequest?) -> AnyPublisher<T, NetworkError> {
        
        guard let request = request else {
            return Fail(error: NetworkError.invalidRequest).eraseToAnyPublisher()
        }
        
        return self.session.dataTaskPublisher(with: request)
            .delay(for: DebugSettings.shared.apiRLDelayTimeThrottle, scheduler: RunLoop.current)
            .tryMap { map in
                if let httpsResponse = map.response as? HTTPURLResponse,
                   !(200..<300).contains(httpsResponse.statusCode) {
                    throw NetworkError.badStatusCode(httpsResponse.statusCode)
                }
                return map.data
            }.decode(type: T.self, decoder: self.decoder)
            .mapError { error in
                if let statusCodeErr = error as? NetworkError {
                    return statusCodeErr
                }
                if let decodeError = error as? DecodingError {
                    return NetworkError.decodeError(decodeError)
                }
                return NetworkError.other(error)
            }.eraseToAnyPublisher()
        
    }
    
    
    func fetchData(request: URLRequest?) -> AnyPublisher<Data, NetworkError> {
        
        guard let request = request else {
            return Fail(error: NetworkError.invalidRequest).eraseToAnyPublisher()
        }
        
        return self.session.dataTaskPublisher(with: request)
            .delay(for: DebugSettings.shared.imageRLDelayTimeThrottle, scheduler: RunLoop.current)
            .tryMap { map in
                if let httpsResponse = map.response as? HTTPURLResponse,
                   !(200..<300).contains(httpsResponse.statusCode) {
                    throw NetworkError.badStatusCode(httpsResponse.statusCode)
                }
                return map.data
            }
            .mapError { error in
                if let statusCodeErr = error as? NetworkError {
                    return statusCodeErr
                }
                return NetworkError.other(error)
            }.eraseToAnyPublisher()
        
    }
    
}
