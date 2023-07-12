//
//  EnvironmentTests.swift
//  BasicWeatherAppTests
//
//  Created by iAskedYou2nd on 7/11/23.
//

import XCTest
@testable import BasicWeatherApp

final class EnvironmentTests: XCTestCase {
    
    /// Test proper creation of a Weather Coordinate Request
    func testWeatherCoordinatesRequest() {
        let request = Environment.weatherCoordinates(37.3323, -122.0312).request
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=37.3323&lon=-122.0312&appid=27223ecc8b48060bb0826dacc16e5465&units=imperial")
        XCTAssertEqual(request?.url, url)
    }
    
    /// Test proper creation of a Weather Search Query Request
    func testWeatherSearchQueryRequest() {
        let request = Environment.weatherSearchQuery("Cupertino").request
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=Cupertino&appid=27223ecc8b48060bb0826dacc16e5465&units=imperial")
        XCTAssertEqual(request?.url, url)
    }
    
    /// Test proper creation of a Weather Icon Request
    func testWeatherIconRequest() {
        let request = Environment.weatherIcon("01d").request
        let url = URL(string: "https://openweathermap.org/img/wn/01d@2x.png")
        XCTAssertEqual(request?.url, url)
    }

}
