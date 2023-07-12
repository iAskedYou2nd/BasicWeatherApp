//
//  MockURLSession.swift
//  BasicWeatherAppTests
//
//  Created by iAskedYou2nd on 7/11/23.
//

import Foundation
import Combine
@testable import BasicWeatherApp

enum MockRequestPaths: String {
    case success = "Success"
    case statusCodeFailure = "StatusCodeFailure"
    case decodeFailure = "DecodeFailure"
    case unknownFailure = "UnknownFailure"
    
    static func CreateMockDecodingError() -> DecodingError {
        return DecodingError.dataCorrupted(.init(codingPath: [MockModel.CodingKeys.testString], debugDescription: "Test"))
    }
}

class MockURLSession: PublisherSession {
    
    func dataTaskPublisher(with request: URLRequest) -> AnyPublisher<URLSession.DataTaskPublisher.Output, URLSession.DataTaskPublisher.Failure> {
        
        let strURL = request.url?.lastPathComponent
        let path = MockRequestPaths(rawValue: strURL!)
        
        switch path {
        case .success:
            return Future() { promise in
                DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                    guard let data = MockDataGenerator().generateMockData(for: "MockWeatherData", extensionType: "json"),
                          let url = request.url,
                          let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
                    else { return }
                    
                    promise(.success((data, response)))
                }
            }.eraseToAnyPublisher()
        case .statusCodeFailure:
            return Future() { promise in
                DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                    guard let url = request.url,
                          let response = HTTPURLResponse(url: url, statusCode: 404, httpVersion: nil, headerFields: nil)
                    else { return }
                    
                    promise(.success((Data(), response)))
                }
            }.eraseToAnyPublisher()
        case .decodeFailure:
            return Future() { promise in
                DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                    guard let data = MockModel.sample.data,
                          let url = request.url,
                          let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
                    else { return }
                    
                    promise(.success((data, response)))
                }
            }.eraseToAnyPublisher()
        case .unknownFailure:
            return Future() { promise in
                DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                    let error = URLError(.badServerResponse)
                    promise(.failure(error))
                }
            }.eraseToAnyPublisher()
        default:
            fatalError("This should never happen")
        }
        
        
        
        
        
        

    }
    
    
}
