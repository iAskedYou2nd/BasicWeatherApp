import UIKit
import Combine

class DelayableSubject<Output, Failure>: Publisher where Failure: Error {
    
    private var subscriptions: [AnySubscriber<Output, Failure>] = []
    
    func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        let subscriber = AnySubscriber(subscriber)
        subscriptions.append(subscriber)
    }
    
    func sendWithDelay(of timeInterval: DispatchTimeInterval = DebugSettings.shared.animationDelayTimeThrottle, _ output: Output) {
        DispatchQueue.global().asyncAfter(deadline: .now() + timeInterval) {
            for subscriber in self.subscriptions {
                _ = subscriber.receive(output)
            }
        }
    }

}

class Sender {
    
    let willFail: Bool
    
    init(willFail: Bool = false) {
        self.willFail = willFail
    }
    
    let delayedPub = DelayableSubject<Result<Coordinates, Error>, Never>()
    
    func fire(model: Coordinates) {
        if self.willFail {
            self.delayedPub.sendWithDelay(of: .seconds(3), .failure(NSError(domain: "MyDomain", code: 0)))
        } else {
            self.delayedPub.sendWithDelay(of: .seconds(3), .success(model))
        }
        
    }
    
}

class Receiver {
    
    var subs = Set<AnyCancellable>()
    let sender: Sender
    
    init(sender: Sender) {
        self.sender = sender
    }
    
    func bind() {
        self.sender.delayedPub.sink { result in
            switch result {
            case .success(let model):
                print(model)
            case .failure(let err):
                print(err)
            }
        }.store(in: &self.subs)
    }
    
}

let sender = Sender(willFail: true)
let receiverA = Receiver(sender: sender)
receiverA.bind()
let receiverB = Receiver(sender: sender)
receiverB.bind()
let model = Coordinates(lon: 2.0, lat: 4.5)
sender.fire(model: model)


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
            DispatchQueue.global().asyncAfter(deadline: .now() + DebugSettings.shared.animationDelayTimeThrottle) {
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
