//
//  NetworkError.swift
//  BasicWeatherApp
//
//  Created by iAskedYou2nd on 5/31/23.
//

import Foundation

enum NetworkError: Error {
    case invalidRequest
    case badStatusCode(_ statusCode: Int)
    case decodeError(_ decodeError: DecodingError)
    case other(Error)
}

extension NetworkError {
    
    var errorDescription: String? {
        switch self {
        case .invalidRequest:
            return "Invalid Request, Check Created Request"
        case .badStatusCode(let statusCode):
            return "Bad Server Response. Status Code: \(statusCode), check request or try again later"
        case .decodeError(let decodeError):
            return "Decoding Error: \(decodeError)"
        case .other(let error):
            return "Unknown Error. Information: \(error)"
        }
    }
    
}
