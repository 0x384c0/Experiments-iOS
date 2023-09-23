//
// Created on: 23/9/23

import Foundation

/**
 asynchronous and parallel operations

 Opinion:
 awkward, inconsistent
 */
class SwiftConcurrencyExample {
    /**
     unit of asynchronous work
     can be cancelled
     */
    func exampleTask() async {
        let t1 = Task(priority: .background) {
            longTask("task 1")
            return "value"
        }
        let t2 = Task(priority: .high) {
            longTask("task 2")
        }
        DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(500)){
            print("task 2 cancel()")
            t2.cancel() // will cause Task.checkCancellation() to throw a crash
        }
        print("await t1.value \(await t1.value)")
    }

    /**
     group that contains dynamically created child tasks
     */
    func exampleTaskGroup() async {
        let result = await withTaskGroup(of: String.self) { group in
            let t1 = Task(priority: .background) {
                longTask("task 1")
                return "value 1"
            }
            group.addTask {
                await t1.value
            }

            let t2 = Task(priority: .background) {
                longTask("task 2")
                return "value 2"
            }
            group.addTask {
                await t2.value
            }

            var collected = [String]()

            for await value in group { // getting values from all result
                collected.append(value)
            }

            return collected.joined(separator: ", ")
        }
        print("Task group result \(result)")
    }

    //MARK: actors
    /**
     like classes that are safe to use in concurrent environments
     @MainActor - forces all operation in main thread
     @Sendable - data that can safely be transferred to another thread
     */
    actor ActorModel {
        private(set) var value = 0

        func increment() async { // all methods are atomic
            value += 1
            sleep(1)
            value += 1
        }
    }
    class NonActorModel {
        private(set) var value = 0

        func increment() {  // methods are non atomic
            value += 1
            sleep(1)
            value += 1
        }
    }

    func exampleActor() async {
        let actorModel = ActorModel()
        DispatchQueue.global().async {
            Task {
                await actorModel.increment()
                await print("actorModel \(actorModel.value)")
            }
        }
        DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(500)){
            Task {
                await actorModel.increment()
                await print("actorModel \(actorModel.value)")
            }
        }

        sleep(1)

        let nonActorModel = NonActorModel()
        DispatchQueue.global().async {
            Task {
                nonActorModel.increment()
                print("nonActorModel \(nonActorModel.value)")
            }
        }
        DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(500)){
            Task {
                nonActorModel.increment()
                print("nonActorModel \(nonActorModel.value)")
            }
        }
    }


    //MARK: private
    private let LONG_TIME: UInt32 = 1

    private func longTask(_ id:String, timeMult: UInt32 = 1) {
        print("Long task started isMain: \(Thread.isMainThread) id: \(id)")
        sleep(LONG_TIME * timeMult)
        do {
            try Task.checkCancellation()
            print("Long task completed isMain: \(Thread.isMainThread) id: \(id)")
        } catch {
            print("Long task cancelled isMain: \(Thread.isMainThread) id: \(id)")
        }
    }
}
