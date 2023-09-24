//
// Created on: 23/9/23

import Foundation

/**
 encapsulate and perform tasks using Objective-C objects
 
 Opinion:
 lacks features compared to combine or RxSwift
 harder to read
 everything looks implicit
 */
class OperationExample {
    /**
     manages the concurrent execution of one or more block
     
     atomic, cannot be canceled mid execution
     */
    func exampleBlockOperation(){
        let op = BlockOperation(){
            self.longTask("block 1")
        }
        op.addExecutionBlock {
            self.longTask("block 2")
            op.cancel()
            _ = op.isCancelled
        }
        op.addExecutionBlock {
            self.longTask("block 3")
        }
        print("BlockOperation start")
        op.start()
    }
    
    /**
     queue that regulates the execution of operations
     */
    func exampleOperationQueue(){
        let queue = OperationQueue() // or .main
        queue.underlyingQueue = DispatchQueue.global()
        queue.isSuspended = true // suspend or task will start at moment when added
        queue.maxConcurrentOperationCount = 1 // all ops in this quqe will be exeuted syncroniosly (1 op at time)
        
        let op = BlockOperation(){ // all block in this op will be exeuted asyncroniosly, next op will run after all blocks in this op will finish
            self.longTask("op 1 block 1")
        }
        op.addExecutionBlock {
            self.longTask("op 1 block 2", timeMult: 2)
            op.cancel()
        }
        queue.addOperation(op)
        queue.addOperation(BlockOperation(){
            self.longTask("op 2 progress: \(queue.progress.fractionCompleted)")
        })
        queue.addOperation(BlockOperation(){
            self.longTask("op 3 progress: \(queue.progress.fractionCompleted)")
        })
        
        print("BlockOperation start")
        queue.isSuspended = false
    }
    
    // NSInvocationOperation same but with selectors
    
    //MARK: private
    private let LONG_TIME: UInt32 = 1
    
    private func longTask(_ id:String, timeMult: UInt32 = 1){
        print("Long task started isMain: \(Thread.isMainThread) id: \(id)")
        sleep(LONG_TIME * timeMult)
        print("Long task completed isMain: \(Thread.isMainThread) id: \(id)")
    }
}
