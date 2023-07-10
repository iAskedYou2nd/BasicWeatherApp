//
//  NetworkManagerTests.swift
//  BasicWeatherAppTests
//
//  Created by iAskedYou2nd on 7/11/23.
//

import XCTest
import Combine
@testable import BasicWeatherApp

final class NetworkManagerTests: XCTestCase {

    var sut: NetworkManager!
    var subscriptions: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        self.sut = NetworkManager(session: MockURLSession())
        self.subscriptions = Set<AnyCancellable>()
    }

    override func tearDownWithError() throws {
        self.sut = nil
        self.subscriptions = nil
        try super.tearDownWithError()
    }

    /// Tests if successfully able to fetch decodable model data
    func testSuccessFetchModel() {
        var weatherModel: WeatherModel?
        let expectation = XCTestExpectation(description: "Successfully fetched weather data")
        
        let url = URL(string: "https://Mock.com/\(MockRequestPaths.success.rawValue)")!
        let request = URLRequest(url: url)
        
        self.sut.fetchModel(request: request)
            .sink { completion in
                switch completion {
                case .failure:
                    XCTFail("This test is checking for a success")
                default:
                    print("Completion")
                }
            } receiveValue: { (model: WeatherModel) in
                weatherModel = model
                expectation.fulfill()
            }.store(in: &self.subscriptions)
        wait(for: [expectation], timeout: 2)
        
        XCTAssertEqual(weatherModel?.name, "Cupertino")
        XCTAssertEqual(weatherModel?.coord.lat, 37.3323)
        XCTAssertEqual(weatherModel?.coord.lon, -122.0312)
        XCTAssertEqual(weatherModel?.weather.first?.id, 800)
    }
    
    /// Test if properly handling an invalid request for model data
    func testFailureInvalidRequestModel() {
        var failure: NetworkError?
        let expectation = XCTestExpectation(description: "Passed an invalid URLRequest")
        
        let request: URLRequest? = nil
        
        self.sut.fetchModel(request: request)
            .sink { completion in
                switch completion {
                case .failure(let err):
                    failure = err
                    expectation.fulfill()
                default:
                    print("Completion")
                }
            } receiveValue: { (model: WeatherModel) in
                XCTFail("This test is checking for a failure")
            }.store(in: &self.subscriptions)
        wait(for: [expectation], timeout: 0.1)
        
        XCTAssertEqual(failure, NetworkError.invalidRequest)
    }
    
    /// Test if properly handling an invalid status code response for model data
    func testFailureBadStatusCodeModel() {
        var failure: NetworkError?
        let expectation = XCTestExpectation(description: "Received a bad status code")
        
        let url = URL(string: "https://Mock.com/\(MockRequestPaths.statusCodeFailure.rawValue)")!
        let request = URLRequest(url: url)
        
        self.sut.fetchModel(request: request)
            .sink { completion in
                switch completion {
                case .failure(let err):
                    failure = err
                    expectation.fulfill()
                default:
                    print("Completion")
                }
            } receiveValue: { (model: WeatherModel) in
                XCTFail("This test is checking for a failure")
            }.store(in: &self.subscriptions)
        wait(for: [expectation], timeout: 2)
        
        XCTAssertEqual(failure, NetworkError.badStatusCode(404))
    }
    
    /// Test if properly handling decode failes with model data
    func testFailureDecodeModel() {
        var failure: NetworkError?
        let expectation = XCTestExpectation(description: "Unable to decode data")
        
        let url = URL(string: "https://Mock.com/\(MockRequestPaths.decodeFailure.rawValue)")!
        let request = URLRequest(url: url)
        
        self.sut.fetchModel(request: request)
            .sink { completion in
                switch completion {
                case .failure(let err):
                    failure = err
                    expectation.fulfill()
                default:
                    print("Completion")
                }
            } receiveValue: { (model: WeatherModel) in
                XCTFail("This test is checking for a failure")
            }.store(in: &self.subscriptions)
        wait(for: [expectation], timeout: 2)
                
        XCTAssertEqual(failure, NetworkError.decodeError(
            MockRequestPaths.CreateMockDecodingError()))
    }
    
    /// Test if properly handling for a generic unknown error
    func testFailureUnknownModel() {
        var failure: NetworkError?
        let expectation = XCTestExpectation(description: "Unknown Error")
        
        let url = URL(string: "https://Mock.com/\(MockRequestPaths.unknownFailure.rawValue)")!
        let request = URLRequest(url: url)
        
        self.sut.fetchModel(request: request)
            .sink { completion in
                switch completion {
                case .failure(let err):
                    failure = err
                    expectation.fulfill()
                default:
                    print("Completion")
                }
            } receiveValue: { (model: WeatherModel) in
                XCTFail("This test is checking for a failure")
            }.store(in: &self.subscriptions)
        wait(for: [expectation], timeout: 2)
                
        XCTAssertEqual(failure, NetworkError.other(URLError(.badServerResponse)))
    }
    
    /// Test if succssfully able to fetch raw data
    func testSuccessFetchData() {
        var data: Data?
        let expectation = XCTestExpectation(description: "Successfully fetched weather data")
        
        let url = URL(string: "https://Mock.com/\(MockRequestPaths.success.rawValue)")!
        let request = URLRequest(url: url)
        
        self.sut.fetchData(request: request)
            .sink { completion in
                switch completion {
                case .failure:
                    XCTFail("This test is checking for a success")
                default:
                    print("Completion")
                }
            } receiveValue: { rawData in
                data = rawData
                expectation.fulfill()
            }.store(in: &self.subscriptions)
        wait(for: [expectation], timeout: 2)
        
        XCTAssertEqual(data, MockDataGenerator().generateMockData(for: "MockWeatherData", extensionType: "json"))
    }
    
    /// Test if properly handling an invalid request for raw data
    func testFailureInvalidRequestData() {
        var failure: NetworkError?
        let expectation = XCTestExpectation(description: "Passed an invalid URLRequest")
        
        let request: URLRequest? = nil
        
        self.sut.fetchData(request: request)
            .sink { completion in
                switch completion {
                case .failure(let err):
                    failure = err
                    expectation.fulfill()
                default:
                    print("Completion")
                }
            } receiveValue: { _ in
                XCTFail("This test is checking for a failure")
            }.store(in: &self.subscriptions)
        wait(for: [expectation], timeout: 0.1)
        
        XCTAssertEqual(failure, NetworkError.invalidRequest)
    }
    
    /// Test if properly handling a bad status code for raw data
    func testFailureBadStatusCodeData() {
        var failure: NetworkError?
        let expectation = XCTestExpectation(description: "Received a bad status code")
        
        let url = URL(string: "https://Mock.com/\(MockRequestPaths.statusCodeFailure.rawValue)")!
        let request = URLRequest(url: url)
        
        self.sut.fetchData(request: request)
            .sink { completion in
                switch completion {
                case .failure(let err):
                    failure = err
                    expectation.fulfill()
                default:
                    print("Completion")
                }
            } receiveValue: { _ in
                XCTFail("This test is checking for a failure")
            }.store(in: &self.subscriptions)
        wait(for: [expectation], timeout: 2)
        
        XCTAssertEqual(failure, NetworkError.badStatusCode(404))
    }
    
    /// Test for a generic error for raw data
    func testFailureUnknownData() {
        var failure: NetworkError?
        let expectation = XCTestExpectation(description: "Unknown Error")
        
        let url = URL(string: "https://Mock.com/\(MockRequestPaths.unknownFailure.rawValue)")!
        let request = URLRequest(url: url)
        
        self.sut.fetchData(request: request)
            .sink { completion in
                switch completion {
                case .failure(let err):
                    failure = err
                    expectation.fulfill()
                default:
                    print("Completion")
                }
            } receiveValue: { _ in
                XCTFail("This test is checking for a failure")
            }.store(in: &self.subscriptions)
        wait(for: [expectation], timeout: 2)
                
        XCTAssertEqual(failure, NetworkError.other(URLError(.badServerResponse)))
    }

}
