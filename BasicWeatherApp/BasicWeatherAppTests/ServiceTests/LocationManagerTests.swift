//
//  LocationManagerTests.swift
//  BasicWeatherAppTests
//
//  Created by iAskedYou2nd on 7/11/23.
//

import XCTest
import Combine
@testable import BasicWeatherApp

final class LocationManagerTests: XCTestCase {

    var subscriptions: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        self.subscriptions = Set<AnyCancellable>()
    }

    override func tearDownWithError() throws {
        self.subscriptions = nil
        try super.tearDownWithError()
    }
    
    /// Test Location Manager successfully updates coordinate location
    func testSuccessCoordinatesUpdated() {
        let sut = LocationManager(manager: MockLocationService(shouldSucceed: true))
        let expectation = XCTestExpectation(description: "Success on getting coordinates")
        var coordinates: Coordinates?
        
        sut.currentLocationPublisher
            .sink { completion in
                print("Completion")
            } receiveValue: { coords in
                coordinates = coords
                expectation.fulfill()
            }.store(in: &self.subscriptions)
        
        sut.requestLocation()
        wait(for: [expectation], timeout: 2)

        XCTAssertEqual(coordinates, Coordinates(lon:  -122.0312, lat: 37.3323))
    }
    
    /// Test Location manager fails to update coordinates
    func testFailedCoordinatesUpdated() {
        let sut = LocationManager(manager: MockLocationService(shouldSucceed: false))
        let expectation = XCTestExpectation(description: "Failure on getting coordinates")
        var error: Error?

        sut.currentLocationPublisher
            .sink { completion in
                switch completion {
                case .failure(let err):
                    error = err
                    expectation.fulfill()
                default:
                    print("Completion")
                }
            } receiveValue: { _ in
                XCTFail("Should Not get coords")
            }.store(in: &self.subscriptions)
        
        sut.requestLocation()
        wait(for: [expectation], timeout: 2)
        
        XCTAssertEqual(error?.localizedDescription, NSError(domain: "Error", code: 0).localizedDescription)
    }

}
