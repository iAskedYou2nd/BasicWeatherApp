//
//  CacheType.swift
//  BasicWeatherApp
//
//  Created by iAskedYou2nd on 5/31/23.
//

import Foundation
import Combine

protocol CacheType {
    func set(_ data: Data, for key: String)
    func get(for key: String) -> AnyPublisher<Data?, Never>
    func purgeCache()
}
