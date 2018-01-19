//
//  StringUtils.swift
//  IOSExperiments
//
//  Created by 0x384c0 on 21.12.16.
//  Copyright © 2016 0x384c0. All rights reserved.
//

extension String{
    var withCurrency:String{
//        print("12312.3123".replaceWithRegExp(find: "([.]0$)", replace: "--").replaceWithRegExp(find: "([.]00$)", replace: "==="))
//        print("12312.01".replaceWithRegExp(find: "([.]0$)", replace: "--").replaceWithRegExp(find: "([.]00$)", replace: "==="))
//        print("12312.10".replaceWithRegExp(find: "([.]0$)", replace: "--").replaceWithRegExp(find: "([.]00$)", replace: "==="))
//        print("12312.3".replaceWithRegExp(find: "([.]0$)", replace: "--").replaceWithRegExp(find: "([.]00$)", replace: "==="))
//        print("12312.00".replaceWithRegExp(find: "([.]0$)", replace: "--").replaceWithRegExp(find: "([.]00$)", replace: "==="))
//        print("12312.0".replaceWithRegExp(find: "([.]0$)", replace: "--").replaceWithRegExp(find: "([.]00$)", replace: "==="))
        let result = self
            .replaceWithRegExp(find: "([.]0$)", replace: "")
            .replaceWithRegExp(find: "([.]00$)", replace: "")
        return "\(result) \(Constants.CURRENCY_SYM)"
    }
}

class StringUtils{
    static func getStringWithNum(number:Int,nominative:String,accusativeSingle:String,accusativeMany:String) -> String{
        let cases = declOfNum(number:number)
        switch cases {
        case 1:
            return accusativeSingle
        case 2:
            return accusativeMany
        default:
            return nominative
        }
    }
    /**
     # declOfNum
     склонение существительных после числительных.
     
     - Parameter number: Число
     
     - Returns: id существительного. например:["комментарий","комментария","комментариев"]
     */
    static private func declOfNum(number:Int) -> Int {
        let cases = [2, 0, 1, 1, 1, 2]
        if(number % 100 > 4 && number % 100 < 20){
            return 2
        } else {
            return cases[safe:min(number%10, 5)] ?? 1
        }
    }
}
