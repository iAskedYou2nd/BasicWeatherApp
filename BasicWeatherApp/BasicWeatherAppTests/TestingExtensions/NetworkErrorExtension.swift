//
//  NetworkErrorExtension.swift
//  BasicWeatherAppTests
//
//  Created by iAskedYou2nd on 7/11/23.
//

import Foundation
@testable import BasicWeatherApp

extension NetworkError: Equatable {
    
    static public func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        return lhs.equatableDescription == rhs.equatableDescription
    }
    
    private var equatableDescription: String {
        switch self {
        case .invalidRequest:
            return "Invalid Request"
        case .badStatusCode:
            return "Bad Status Code"
        case .decodeError:
            return "Decoding Error"
        case .other:
            return "Unknown Error"
        }
    }
    
}

