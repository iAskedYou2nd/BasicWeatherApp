//
//  MockDataGenerator.swift
//  BasicWeatherAppTests
//
//  Created by iAskedYou2nd on 7/10/23.
//

import Foundation

class MockDataGenerator {
    
    func generateMockData(for name: String, extensionType: String) -> Data? {
        guard let path = Bundle(for: Self.self).url(forResource: name, withExtension: extensionType) else { return nil }
        return try? Data(contentsOf: path)
    }
    
}
