import Foundation
import RxSwift
import SwiftRex

extension PublisherType: ObservableConvertibleType, ObservableType {
    public func subscribe<Observer>(_ observer: Observer) -> Disposable
        where Observer: ObserverType, Element == Observer.Element {
        let subscriber: SubscriberType<Element, ErrorType> = .init(
            onValue: observer.onNext,
            onCompleted: { error in
                if let error = error {
                    observer.onError(error)
                    return
                }
                observer.onCompleted()
            }
        )
        let subscription: SubscriptionType = self.subscribe(subscriber)
        return subscription.asDisposable()
    }
}

extension ObservableType {
    public func asPublisher() -> PublisherType<Element, Error> {
        .init { (subscriber: SubscriberType<Element, Error>) -> SubscriptionType in
            self.subscribe(subscriber.asObserver()).asSubscription()
        }
    }
}
