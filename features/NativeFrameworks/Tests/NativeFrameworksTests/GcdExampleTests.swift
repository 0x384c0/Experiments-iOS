import XCTest
@testable import NativeFrameworks

final class GcdExampleTests: XCTestCase {
    private let sleepTime:UInt32 = 4
    private let sut = GcdExample()
    func testExampleDispatchQueue() throws {
        print("\nexampleDispatchQueue")
        sut.exampleDispatchQueue()
        sleep(sleepTime)
        print("\n")
    }

    func testExampleDispatchWorkItem(){
        print("\nexampleDispatchWorkItem")
        sut.exampleDispatchWorkItem()
        sleep(sleepTime)
        print("\n")
    }

    func testExampleDispatchGroup(){
        print("\nexampleDispatchGroup")
        sut.exampleDispatchGroup()
        sleep(sleepTime)
        print("\n")
    }

    func testExampleDispatchSource(){
        print("\nexampleDispatchSource")
        sut.exampleDispatchSource()
        sleep(sleepTime)
        print("\n")
    }

    func testExampleDispatchSemaphore(){
        print("\nexampleDispatchSemaphore")
        sut.exampleDispatchSemaphore()
        sleep(sleepTime)
        print("\n")
    }
}
