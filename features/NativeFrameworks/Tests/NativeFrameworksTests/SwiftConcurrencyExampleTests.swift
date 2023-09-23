//
// Created on: 23/9/23

import XCTest
@testable import NativeFrameworks

class SwiftConcurrencyExampleTests : XCTestCase {
    private let sleepTime:UInt32 = 4
    let sut = SwiftConcurrencyExample()

    func testExampleTask() async{
        print("\nexampleTask")
        await sut.exampleTask()
        sleep(sleepTime)
        print("\n")
    }

    func testExampleTaskGroup() async{
        print("\nexampleTaskGroup")
        await sut.exampleTaskGroup()
        sleep(sleepTime)
        print("\n")
    }
    
}
