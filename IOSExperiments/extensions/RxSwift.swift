//
//  PublishSubject.swift
//  yesno
//
//  Created by 0x384c0 on 12/9/15.
//  Copyright © 2015 0x384c0. All rights reserved.
//

import RxSwift

extension PublishSubject {
    public var value: Element {
        get {
            //dont use get
            return self.value
        }
        set {
            self.on(.next(newValue))
        }
    }
}


extension Variable{
    public func observeOn(_ scheduler: ImmediateSchedulerType) -> RxSwift.Observable<Element> {
        return asObservable().observeOn(scheduler).skip(1)
    }
    
    public func subscribeMain(onNext: @escaping ((Variable.E) -> Swift.Void)) -> Disposable{
        return observeOn(MainScheduler.instance).subscribe(onNext: onNext)
    }
}

extension ObservableType{
    public func subscribeMain(onNext: @escaping ((Self.E) -> Swift.Void)) -> Disposable{
        return observeOn(MainScheduler.instance).subscribe(onNext: onNext)
    }
}

