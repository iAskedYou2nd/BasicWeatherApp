//
//  DebugSettings.swift
//  BasicWeatherApp
//
//  Created by iAskedYou2nd on 6/28/23.
//

import Foundation

final class DebugSettings {
    
    static let shared = DebugSettings()
    
    var apiDelayTime: Int = 0
    var apiDQDelayTimeThrottle: DispatchTimeInterval {
        return .seconds(self.apiDelayTime)
    }
    var apiRLDelayTimeThrottle: RunLoop.SchedulerTimeType.Stride {
        return .seconds(self.apiDelayTime)
    }
    
    var imageDelayTime: Int = 0
    var imageDQDelayTimeThrottle: DispatchTimeInterval {
        return .seconds(self.imageDelayTime)
    }
    var imageRLDelayTimeThrottle: RunLoop.SchedulerTimeType.Stride {
        return .seconds(self.imageDelayTime)
    }
    
    
    private init() {}
    
}
