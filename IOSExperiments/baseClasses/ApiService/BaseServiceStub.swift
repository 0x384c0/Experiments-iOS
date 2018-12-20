//
//  BaseServiceStub.swift
//  IOSExperiments
//
//  Created by 0x384c0 on 05.04.17.
//  Copyright © 2017 0x384c0. All rights reserved.
//

import RxSwift

class BaseServiceStub{
    private var
    DELAY:UInt32 = 1,
    RETURN_ERROR = false
    func sendData<T>(_ observer:AnyObserver<T>,_ funcName:String,_ data:T){
        Logger.log("REQUEST: \(funcName)",.info)
        sleep(DELAY)
        if !RETURN_ERROR{
            observer.onNext(data)
        } else {
            let
            userInfo = [
                FailureResponseBodyErrorKey         : "NEWTORK_ERROR"
            ],
            error = NSError(domain: "com.0x384c0", code: 1, userInfo: userInfo)
            observer.onError(error)
        }
    }
    
}
