//
//  IOSExperimentsTests.swift
//  IOSExperimentsTests
//
//  Created by 0x384c0 on 11/13/15.
//  Copyright © 2015 0x384c0. All rights reserved.
//

import XCTest
@testable import IOSExperiments
import SimplifiedNotificationCenter

class IOSExperimentsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testNotifications() {
        let notifications = Notifications()
        testNotification(notifications.boolNot, object: true)
        testNotification(notifications.stringNot, object: "true")
    }
    
    fileprivate func testNotification<T:BaseNotificationProtocol>(_ notification:T,object:T.T){
        print("-+-+-+-+-+-+-+-+-+-+-+\n testing \(#function)\n-+-+-+-+-+-+-+-+-+-+-+")
        let readyExpectation = expectation(description: "ready.\(#function)")
        //test subscribed
        print("SUBSCRIBE")
        notification.subscribe { (value, sender) in
            print("RECEIVE")
            readyExpectation.fulfill()
        }
        print("SEND")
        notification.post(object)
        
        waitForExpectations(timeout: 1){ error in
            XCTAssertNil(error, "\(#function) Error receive notification")
        }
        
        
        //test unsusbscribed
        notification.subscribe { (value, sender) in
            print("RECEIVE")
            XCTAssertTrue(false, "Notification is not unsubscribed")
        }
        print("UNSUBSCRIBE")
        notification.unSubscribe()
        print("SEND")
        notification.post(object)
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    
    //    func testSomething(){
    //        print("-+-+-+-+-+-+-+-+-+-+-+\n testing \(#function)\n-+-+-+-+-+-+-+-+-+-+-+")
    //        let readyExpectation = expectationWithDescription("ready.\(#function)")
    //
    //
    //        waitForExpectationsWithTimeout(40){ error in
    //            XCTAssertNil(error, "\(#function) Error")
    //        }
    //    }
}
