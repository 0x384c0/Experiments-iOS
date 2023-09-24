//
// Created on: 23/9/23

import Combine
import Foundation

class SwiftCombineExample {
    func examplePublishers(){
        let queue = DispatchQueue.global(qos: .background)
        let publisher1 = Just("value 1").delay(for: .seconds(1), scheduler: queue).map { print("isMainThread: \(Thread.isMainThread) value: \($0)"); return $0 }.subscribe(on: queue)
        let publisher2 = Just("value 2").delay(for: .seconds(1), scheduler: queue).map { print("isMainThread: \(Thread.isMainThread) value: \($0)"); return $0 }.subscribe(on: queue)
        let publisher3 = Just("value 3").delay(for: .seconds(1), scheduler: queue).map { print("isMainThread: \(Thread.isMainThread) value: \($0)"); return $0 }.subscribe(on: queue)

        _ = publisher1.zip(publisher2,publisher3)
            .sink { value in
            print(value)
        }
    }

    // Merge simply merges events from all observables of same type in the order they are received, without combining them.
    // CombineLatest combines the latest events from all observables every time any of them emits an event.
}
