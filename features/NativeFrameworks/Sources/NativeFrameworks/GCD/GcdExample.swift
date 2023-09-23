//
// Created on: 23/9/23

import Foundation

/**
 Dispatch GCD , also known as Grand Central Dispatch (GCD),  is a low-level API for managing concurrent operations,
 contains language features, runtime libraries, and system enhancements that provide systemic,
 comprehensive improvements to the support for concurrent code execution on multicore hardware in macOS, iOS, watchOS, and tvOS.

 Opinion:

 Pros:
 faster (maybe?)
 allows precise tuning
 no dependencies

 Cons:
 harder to read
 allow to mix async code with logic
 more room for mistakes

 Overall this is example how to not create a library for writing async code
 */
public class GcdExample {
    //MARK: Queues and Tasks
    /**
     Dispatch queues are FIFO queues to which your application can submit tasks in the form of block objects.
     Dispatch queues execute tasks either serially or concurrently.
     Work submitted to dispatch queues executes on a pool of threads managed by the system.

     Attempting to synchronously execute a work item on the main queue results in deadlock.
     */
    func exampleDispatchQueue(){
        //        background - not time-critical
        //        utility - user does not track actively
        //        `default` - default
        //        userInitiated -  initiated by the user and require immediate results, eg UI, inputs
        //        userInteractive -  are time-critical and require immediate user feedback, eg UI, Audio
        //        unspecified - absence
        let queueGlobalBG = DispatchQueue.global(qos: .background) // non-main thread, may temporarily use the main thread
        queueGlobalBG.async {
            self.longTask("queueGlobalBG")
            
            let queueMain = DispatchQueue.main
            queueMain.async { self.longTask("queueMain") }
        }
        //rx Swift uses observeOn, subscribeOn , Scheduler is wrapper

    }

    /**
     encapsulates work to be performed on a dispatch queue or within a dispatch group,
     used when delay or cancel is needed
     */
    func exampleDispatchWorkItem(){
        let itemBG1 = DispatchWorkItem(qos: .background, block: { self.longTask("background 1") })
        let itemBG2 = DispatchWorkItem(qos: .background, block: { self.longTask("background 2") })
        let itemBG3 = DispatchWorkItem(qos: .background, block: { self.longTask("background 3") })
        let queueGlobalBG = DispatchQueue.global(qos: .background)
        itemBG1.notify(queue: queueGlobalBG, execute: itemBG2) // Schedules itemBG2 execution after the completion
        itemBG2.notify(queue: queueGlobalBG, execute: itemBG3)
        itemBG1.perform() // Executes synchronously on the current thread
        itemBG1.wait() // synchronously until the dispatch work item finishes
        DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(Int(1000 * Double(LONG_TIME) * 0.5))) {

            print("itemBG2.cancel()")
            //cancel() will stop tasks from executing if they have yet to be run, but won't halt something that's already executing
            itemBG2.cancel() // will not work, since task alredy running, long task mush check isCancelled flag
            itemBG3.cancel() // will work

        }
    }

    /**
     aggregate a set of tasks and synchronize behaviors on the group
     */
    func exampleDispatchGroup(){
        let group = DispatchGroup()
        let queue = DispatchQueue.global()
        group.enter() // block has entered the group
        queue.async {
            self.longTask("async 1")
            group.leave() // block in the group finished executing
        }

        group.enter()
        queue.async {
            self.longTask("async 2")
            group.leave()
        }

        let itemBG1 = DispatchWorkItem(qos: .background, block: { self.longTask("task 3") })
        group.notify(queue: queue, work: itemBG1)

        group.wait()
    }

    // dispatch_workloop_t unavailable in swift

    /**
     processing of specific low-level system events,
     Opinion: should not be part of GCD
     same for DispatchIO - accessing the contents of a file descriptor, DispatchData
     */
    func exampleDispatchSource() {
        // track all the UNIX signals sent
        let signalSource = DispatchSource.makeSignalSource(signal: SIGSTOP, queue: .main) // SIGABRT
        signalSource.setEventHandler {
            print("signalSource SIGSTOP")
        }
        signalSource.resume()

        // Timer
        let timerSource = DispatchSource.makeTimerSource()
        timerSource.setEventHandler {
            print("timerSource event")
        }
        timerSource.schedule(deadline: .now(), repeating: 0.1)
        timerSource.resume()
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)) { // if use main, fill freeze main thread
            print("timerSource cancel")
            timerSource.cancel()
        }

        // monitors the system for changes in the memory pressure condition
        let memorySource = DispatchSource.makeMemoryPressureSource(eventMask: .warning, queue: .main)
        memorySource.setEventHandler {
            print("memorySource warning")
        }
        memorySource.resume()
    }

    //MARK: Task Synchronization
    /**
     counting semaphore, controls access to a resource across multiple execution contexts
     */
    func exampleDispatchSemaphore(){
        let semaphore = DispatchSemaphore(value: 2)
        let queue = DispatchQueue.global()

        queue.async {
            let timeoutResult = semaphore.wait(timeout: .now() + .seconds(1)) // wait for available
            self.longTask("task 1 timeoutResult: \(timeoutResult)")
            semaphore.signal() // signale that resource released
        }
        queue.async {
            semaphore.wait()
            self.longTask("task 2")
            semaphore.signal()
        }
        queue.async {
            semaphore.wait()
            self.longTask("task 3")
            semaphore.signal()
        }
    }

    //MARK: private
    private let LONG_TIME:UInt32 = 1

    private func longTask(_ id:String){
        print("Long task started isMain: \(Thread.isMainThread) id: \(id)")
        sleep(LONG_TIME)
        print("Long task completed isMain: \(Thread.isMainThread) id: \(id)")
    }
}
