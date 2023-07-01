//
//  DelayablePublisher.swift
//  BasicWeatherApp
//
//  Created by iAskedYou2nd on 6/30/23.
//

import Foundation
import Combine

class DelayableSubject<Output, Failure>: Publisher where Failure: Error {
    
    private var subscriptions: [AnySubscriber<Output, Failure>] = []
    
    func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        let subscriber = AnySubscriber(subscriber)
        subscriptions.append(subscriber)
    }
    
    func sendWithDelay(of timeInterval: DispatchTimeInterval = DebugSettings.shared.apiDQDelayTimeThrottle, _ output: Output) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            for subscriber in self.subscriptions {
                _ = subscriber.receive(output)
            }
        }
    }

}

@propertyWrapper
class DelayablePublished<T> {
    
    typealias DelayedPublisher = PassthroughSubject<Result<T, Error>, Never>
    
    private let delayablePublisher = DelayedPublisher()
    private var internalValue: T?
    
    var wrappedValue: T? {
        get {
            return self.internalValue
        }
        set {
            self.internalValue = newValue
            DispatchQueue.global().asyncAfter(deadline: .now() + DebugSettings.shared.apiDQDelayTimeThrottle) {
                if let value = self.internalValue {
                    self.delayablePublisher.send(.success(value))
                } else {
                    self.delayablePublisher.send(.failure(NSError(domain: "Error", code: 0)))
                }
            }
        }
    }
    
    init(wrappedValue: T?) {
        self.wrappedValue = wrappedValue
    }
    
    var projectedValue: DelayedPublisher {
        return self.delayablePublisher
    }

}
