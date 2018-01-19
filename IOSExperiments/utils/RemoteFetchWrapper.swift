//
//  RemoteFetchWrapper.swift
//  IOSExperiments
//
//  Created by 0x384c0 on 20.06.17.
//  Copyright © 2017 0x384c0. All rights reserved.
//
import RxSwift

class RemoteFetchWrapper {
    
    static var isEnabled:Bool{
        get {
            return AppUserDefaults.isRemoteFetchEnabed
        }
        set {
            if newValue{
                enable()
            } else {
                disable()
            }
            AppUserDefaults.isRemoteFetchEnabed = newValue
        }
    }
    
    private static func enable(){
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
    }
    private static func disable(){
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalNever)
        AppUserDefaults.remoteFetchLog = nil
    }
    
    
    static var disposable:Disposable?
    static func performFetchWithCompletionHandler(_ completionHandler: @escaping (UIBackgroundFetchResult) -> Void){
        disposable = GoogleService()
            .loadApiList()
            .subscribe(
                onNext: { data in
                    var text = AppUserDefaults.remoteFetchLog ?? ""
                    text += "\(Date())\n\(data.kind ?? "nil")\n------------\n"
                    AppUserDefaults.remoteFetchLog = text
                    
                    print(AppUserDefaults.remoteFetchLog ?? "nil")
                    completionHandler(.newData)
                    
            },
                onError:{ _ in
                    completionHandler(.failed)
                    
            })
    }
}
