//
//  ImageCache.swift
//  BasicWeatherApp
//
//  Created by iAskedYou2nd on 5/31/23.
//

import Foundation

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
    
    func get(for key: String) -> Data? {
        let nsKey = NSString(string: key)
        guard let objc = self.cache.object(forKey: nsKey) else { return nil }
        return Data(referencing: objc)
    }
    
    func purgeCache() {
        self.cache.removeAllObjects()
    }
    
}
