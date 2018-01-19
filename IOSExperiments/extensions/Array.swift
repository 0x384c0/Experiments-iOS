//
//  Array.swift
//  iosExperiments
//
//  Created by 0x384c0 on 1/25/16.
//  Copyright © 2016 0x384c0. All rights reserved.
//

extension Array {
    subscript (safe index: UInt) -> Element? {
        return (Int(index) < count && Int(index) >= 0) ? self[Int(index)] : nil
    }
    
    subscript (safe index: Int) -> Element? {
        return (Int(index) < count && Int(index) >= 0) ? self[Int(index)] : nil
    }
    
    mutating func append(safe element:Element?){
        if let element = element{
            append(element)
        }
        
    }
}

extension Dictionary {
    @discardableResult
    mutating func updateValue(safe value: Value?, forKey key: Key) -> Value?{
        if let value = value {
            return updateValue(value,forKey: key)
        } else {
            return nil
        }
    }
}
