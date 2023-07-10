//
//  NetworkErrorTests.swift
//  BasicWeatherAppTests
//
//  Created by iAskedYou2nd on 7/11/23.
//

import XCTest
@testable import BasicWeatherApp

final class NetworkErrorTests: XCTestCase {
    
    /// Test getting Invalid Request Network Error
    func testInvalidRequestDescription() {
        let error = NetworkError.invalidRequest
        XCTAssertEqual(error.errorDescription, "Invalid Request, Check Created Request")
    }
    
    /// Test getting Bad Status Code Network Error
    func testBadStatusCodeDescription() {
        let error = NetworkError.badStatusCode(404)
        XCTAssertEqual(error.errorDescription, "Bad Server Response. Status Code: 404, check request or try again later")
    }
    
    /// Test getting DEcode Error Network Error
    func testDecodeErrorDescription() {
        let error = NetworkError.decodeError(MockRequestPaths.CreateMockDecodingError())
        XCTAssertEqual(error.errorDescription, "Decoding Error: dataCorrupted(Swift.DecodingError.Context(codingPath: [CodingKeys(stringValue: \"testString\", intValue: nil)], debugDescription: \"Test\", underlyingError: nil))")
    }
    
    /// Test getting Generic Error Network Error
    func testOtherDescription() {
        let error = NetworkError.other(NSError(domain: "1", code: 1))
        XCTAssertEqual(error.errorDescription, "Unknown Error. Information: Error Domain=1 Code=1 \"(null)\"")
    }
    
}
