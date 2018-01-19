//
//  Date.swift
//  IOSExperiments
//
//  Created by 0x384c0 on 19.12.16.
//  Copyright © 2016 0x384c0. All rights reserved.
//

extension Date{
    var daysSince1970:Int{
        return Int(timeIntervalSince1970 / (60 * 60 * 24))
    }
    
    /// EZSE: Converts NSDate to String, with format
    public func toStringRu(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.string(from: self)
    }
}
