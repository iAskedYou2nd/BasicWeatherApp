//
//  QuerySanitizer.swift
//  BasicWeatherApp
//
//  Created by iAskedYou2nd on 6/2/23.
//

import Foundation

class QuerySanitizer {
    
    static func sanitizeWeatherQuery(for query: String) -> String {
        return query.trimmingCharacters(in: .whitespacesAndNewlines)
                    .replacingOccurrences(of: ", ", with: ",")
                    .replacingOccurrences(of: " ", with: ",")
    }
    
}
