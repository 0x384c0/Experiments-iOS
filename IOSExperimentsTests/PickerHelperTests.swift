//
//  MoversTests.swift
//  MoversTests
//
//  Created by Andrew Ashurov on 12/18/18.
//  Copyright © 2018 0x384c0. All rights reserved.
//

import XCTest
@testable import Movers

class PickerHelperTests: XCTestCase {
    let items = ["i1","i2"]
    var item:String!
    var object:PickerHelper!
    override func setUp() {
        object = PickerHelper()
        object.setup(items: items, textField: UITextField(frame: CGRect.zero), changeHandler: {item in self.item = item})
    }

    override func tearDown() {
        object = nil
    }

    func testDatasource() {
        XCTAssert(object.numberOfComponents(in: UIPickerView()) == 1)
        XCTAssert(object.pickerView(UIPickerView(), numberOfRowsInComponent: 0) == items.count)
        XCTAssert(object.pickerView(UIPickerView(), titleForRow: 0, forComponent: 0) == items.first)
    }
    
    func testDelegate(){
        object.pickerView(UIPickerView(), didSelectRow: 0, inComponent: 0)
        XCTAssert(item == items.first)
    }

}
