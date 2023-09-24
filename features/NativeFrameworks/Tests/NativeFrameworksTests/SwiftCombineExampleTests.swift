//
// Created on: 24/9/23

import XCTest
@testable import NativeFrameworks

class SwiftCombineExampleTests: XCTestCase {
    
    private let sleepTime:UInt32 = 4
    let sut = SwiftCombineExample()

    func testExamplePublishers(){
        print("\nexamplePublishers")
        sut.examplePublishers()
        sleep(sleepTime)
        print("\n")
    }
}
