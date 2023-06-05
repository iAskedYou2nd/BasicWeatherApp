//
//  NetworkManagerType.swift
//  BasicWeatherApp
//
//  Created by iAskedYou2nd on 5/31/23.
//

import Foundation
import Combine

protocol NetworkManagerType {
    func fetchModel<T: Decodable>(request: URLRequest?) -> AnyPublisher<T, NetworkError>
    func fetchData(request: URLRequest?) -> AnyPublisher<Data, NetworkError>
}
