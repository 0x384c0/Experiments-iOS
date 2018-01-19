//
//  InfixOperators.swift
//  iosExperiments
//
//  Created by 0x384c0 on 6/22/16.
//  Copyright © 2016 0x384c0. All rights reserved.
//

import Foundation


//pattern mathing
infix operator =~ : ComparisonPrecedence
func =~(string:String, regex:String) -> Bool {
    return string.range(of: regex, options: .regularExpression) != nil
}

//optional string merge
infix operator ?+ : AdditionPrecedence
func ?+ (string1: String?, string2: String?) -> String? {
    if let
        string1 = string1,
        let string2 = string2{
        return string1 + string2
    }
    return nil
}


//precedencegroup CustomPrecGoup{
//    associativity : right
//    higherThan : LogicalConjunctionPrecedence
//}
//infix operator ?+ : CustomPrecGoup
