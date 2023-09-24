//
// Created on: 24/9/23

import XCTest
@testable import NativeFrameworks

class CoreDataExampleTests : XCTestCase {
    private let sut = CoreDataExample()

    func testWrite(){
        let items = 3
        for i in 1...items {
            let id = i
            let value = "test value \(i)"
            sut.addEntity(valueInt: id, valueString: value)
            XCTAssertNotNil(sut.entities?.filter{$0.valueString == value})
        }
        XCTAssertEqual(items, sut.entities?.count)
    }

    func testFetch(){
        let items = 3
        for i in 1...items {
            let id = i
            let value = "test value \(i)"
            sut.addEntity(valueInt: id, valueString: value)
        }
        XCTAssertNotNil(sut.entities?.filter{$0.valueString == "test value \(items - 1)"})
        XCTAssertEqual("test value \(items - 1)", sut.entity(by: items - 1)?.valueString) 
    }


    func testDelete(){
        let items = 3
        for i in 1...items {
            let id = i
            let value = "test value \(i)"
            sut.addEntity(valueInt: id, valueString: value)
        }
        XCTAssertEqual("test value \(items - 1)", sut.entity(by: items - 1)?.valueString)
        sut.delete(by: items - 1)
        XCTAssertNil(sut.entity(by: items - 1))
    }
    
}
