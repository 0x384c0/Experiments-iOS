//
//  Observable.swift
//  iosExperiments
//
//  Created by Andrew Ashurow on 3/15/16.
//  Copyright © 2016 0x384c0. All rights reserved.
//

import RxSwift

class RxSwiftUtils {
    static func getErrorObservable<T>(_ errorTmp:Error) -> Observable<T>{
        return Observable.create { observerTmp in
            observerTmp.on(.error(errorTmp))
            return Disposables.create{ }
        }
    }
}
