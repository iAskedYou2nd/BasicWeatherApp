//
//  DebugSettings.swift
//  BasicWeatherApp
//
//  Created by iAskedYou2nd on 6/28/23.
//

import Foundation

final class DebugSettings {
    
    static let shared = DebugSettings()
    
    var animationDelayTime: Int = 0
    var animationDelayTimeThrottle: DispatchTimeInterval {
        return .seconds(self.animationDelayTime)
    }
    
    
    private init() {}
    
}
