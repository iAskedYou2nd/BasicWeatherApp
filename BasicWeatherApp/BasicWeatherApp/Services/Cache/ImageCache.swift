//
//  ImageCache.swift
//  BasicWeatherApp
//
//  Created by iAskedYou2nd on 5/31/23.
//

import Foundation
import Combine

final class ImageCache {
    
    static let shared = ImageCache()
    private let cache = NSCache<NSString, NSData>()
    
    private init() { }
    
}

extension ImageCache: CacheType {
    
    func set(_ data: Data, for key: String) {
        let objc = NSData(data: data)
        let nsKey = NSString(string: key)
        self.cache.setObject(objc, forKey: nsKey)
    }
    
    func get(for key: String) -> AnyPublisher<Data?, Never> {
        let nsKey = NSString(string: key)
        guard let objc = self.cache.object(forKey: nsKey) else {
            return Just(nil).eraseToAnyPublisher()
        }
        return Just(Data(referencing: objc))
            .delay(for: DebugSettings.shared.imageRLDelayTimeThrottle, scheduler: RunLoop.current)
            .eraseToAnyPublisher()
    }
    
    func purgeCache() {
        self.cache.removeAllObjects()
    }
    
}
