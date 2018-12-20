//
//  BaseResponse.swift
//  IOSExperiments
//
//  Created by 0x384c0 on 12.12.16.
//  Copyright © 2016 0x384c0. All rights reserved.
//

import ObjectMapper

class BaseResponse:Mappable {
    var
    message:String?
    
    // Mappable
    required init?(map: Map) {}
    func mapping(map: Map) {
        message     <- map["message"]
    }
    
    static func parse(_ JSONString:String?) -> BaseResponse?{
        return Mapper<BaseResponse>().map(JSONString: JSONString ?? "nil")
    }
    
    //test
    init(){}
}
