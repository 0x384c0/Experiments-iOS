//
//  AlamofireExtentions.swift
//  IOSExperiments
//
//  Created by 0x384c0 on 12/1/15.
//  Copyright © 2015 0x384c0. All rights reserved.
//

import Alamofire
import RxSwift
import ObjectMapper
import RxAlamofire

extension Reactive where Base: DataRequest {
    public func mappable<T:Mappable>() -> Observable<T>{
        return string()
            .flatMap{ response -> Observable<T> in
                let response = response.isBlank ? "{}" : response
                return Observable.create{ observer in
                    print(response)
                    if let result = Mapper<T>().map(JSONString: response){
                        print(result)
                        observer.onNext(result)
                    } else {
                        let
                        userInfo = [NSLocalizedFailureReasonErrorKey: "JSON_PARSE_ERROR".localized],
                        error = NSError(domain: "com.tmaamv", code: 1, userInfo: userInfo)
                        observer.onError(error)
                    }
                    return Disposables.create()
                }
        }
    }
    
    
    public func mappableArray<T:Mappable>() -> Observable<[T]>{
        return string()
            .flatMap{ response -> Observable<[T]> in
                let response = response.isBlank ? "{}" : response
                return Observable.create{ observer in
                    print(response)
                    if let result = Mapper<T>().mapArray(JSONString: response){
                        print(result)
                        observer.onNext(result)
                    } else {
                        let
                        userInfo = [NSLocalizedFailureReasonErrorKey: "JSON_PARSE_ERROR".localized],
                        error = NSError(domain: "com.com.tmaamv", code: 1, userInfo: userInfo)
                        observer.onError(error)
                    }
                    return Disposables.create()
                }
        }
    }
}



extension Reactive where Base: DataRequest {
    func stringWithBodyInError(encoding: String.Encoding? = nil) -> Observable<String> {
        return resultWithBodyInError(responseSerializer: Base.stringResponseSerializer(encoding: encoding))
    }
    func resultWithBodyInError<T: DataResponseSerializerProtocol>(
        queue: DispatchQueue? = nil,
        responseSerializer: T)
        -> Observable<T.SerializedObject>{
            return Observable.create { observer in
                let dataRequest = self.validateSuccessfulResponseExt()
                    .response(queue: queue, responseSerializer: responseSerializer) { (packedResponse) -> Void in
                        Logger.logResponse(packedResponse: packedResponse)
                        switch packedResponse.result {
                        case .success(let result):
                            if let _ = packedResponse.response {
                                observer.on(.next(result))
                            }
                            else {
                                observer.on(.error(RxAlamofireUnknownError))
                            }
                            observer.on(.completed)
                        case .failure(let error):
                            //add body in to error.userInfo
                            var
                            nserror = (error as NSError),
                            userInfo = nserror.userInfo
                            userInfo.updateValue(error.localizedDescription, forKey: NSLocalizedFailureReasonErrorKey)
                            if let statusCode = packedResponse.response?.statusCode{
                                userInfo.updateValue(statusCode, forKey: FailureStatusCodeErrorKey)
                            }
                            if let data = packedResponse.data,
                                let string = String(data: data, encoding: String.Encoding.utf8){
                                userInfo.updateValue(string, forKey: FailureResponseBodyErrorKey)
                            }
                            let
                            newerror = NSError(domain: nserror.domain, code: nserror.code, userInfo: userInfo)
                            observer.on(.error(newerror as Error))
                        }
                }
                return Disposables.create {
                    dataRequest.cancel()
                }
            }
    }
    /// - returns: A validated request based on the status code
    func validateSuccessfulResponseExt() -> DataRequest {
        return self.base.validate(statusCode: 200 ..< 300)
    }
}
let FailureResponseBodyErrorKey = "FailureResponseBodyErrorKey"
let FailureStatusCodeErrorKey   = "FailureStatusCodeErrorKey"
extension Error{
    var responseBody:String?{
        return ((self as Any) as? NSError)?.userInfo[FailureResponseBodyErrorKey] as? String
    }
    var localizedFailureReason:String?{
        return ((self as Any) as? NSError)?.localizedFailureReason
    }
    var statusCode:NSInteger?{
        return ((self as Any) as? NSError)?.userInfo[FailureStatusCodeErrorKey] as? NSInteger
    }
}
