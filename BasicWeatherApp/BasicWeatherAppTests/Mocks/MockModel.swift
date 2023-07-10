//
//  MockModel.swift
//  BasicWeatherAppTests
//
//  Created by iAskedYou2nd on 7/10/23.
//

import Foundation

struct MockModel: Codable, Equatable {
    
    static let sample = MockModel(testString: "Sample", testInt: 0, testBool: true)
    
    let testString: String
    let testInt: Int
    let testBool: Bool
    
    var data: Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(self)
    }
    
    enum CodingKeys: String, CodingKey {
        case testString
        case testInt
        case testBool
    }
}
