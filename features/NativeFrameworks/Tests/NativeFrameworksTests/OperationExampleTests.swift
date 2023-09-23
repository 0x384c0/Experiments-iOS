//
// Created on: 23/9/23

import XCTest
@testable import NativeFrameworks

class OperationExampleTests: XCTestCase {
    private let sleepTime:UInt32 = 4
    let sut = OperationExample()

    func testExampleBlockOperation(){
        print("\nexampleBlockOperation")
        sut.exampleBlockOperation()
        sleep(sleepTime)
        print("\n")
    }

    func testExampleOperationQueue(){
        print("\nexampleOperationQueue")
        sut.exampleOperationQueue()
        sleep(sleepTime)
        print("\n")
    }
}
