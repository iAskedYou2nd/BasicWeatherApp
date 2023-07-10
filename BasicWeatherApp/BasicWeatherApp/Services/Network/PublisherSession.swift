//
//  PublisherSession.swift
//  BasicWeatherApp
//
//  Created by iAskedYou2nd on 7/11/23.
//

import Foundation
import Combine

protocol PublisherSession {
    func dataTaskPublisher(with request: URLRequest) -> AnyPublisher<URLSession.DataTaskPublisher.Output, URLSession.DataTaskPublisher.Failure>
}

extension URLSession: PublisherSession {
    
    func dataTaskPublisher(with request: URLRequest) -> AnyPublisher<URLSession.DataTaskPublisher.Output, URLSession.DataTaskPublisher.Failure> {
        return self.dataTaskPublisher(for: request).eraseToAnyPublisher()
    }
    
}
