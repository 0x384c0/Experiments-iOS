//
//  BaseService.swift
//  iosExperiments
//
//  Created by 0x384c0 on 3/8/16.
//  Copyright © 2016 0x384c0. All rights reserved.
//


import RxSwift
import Alamofire
import ObjectMapper


class BaseService {
    func createRequest<T:Mappable>(
        url:String,
        parameters: [String: Any]? = nil,
        headers: HTTPHeaders? = nil,
        method: HTTPMethod = .get,
        encoding: ParameterEncoding = URLEncoding.default) -> Observable<T>{
        Logger.logRequest(url: url, parameters: parameters, headers: headers, method: method)
        
        return Alamofire.SessionManager.default.requestWithoutCashe(
            url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "",
            method: method,
            parameters: parameters,
            encoding: encoding,
            headers: headers)
            .rx
            .mappable()
    }
    enum Result{
        case
        success,
        fail,
        none
    }
    
    fileprivate var cachePolicy:URLRequest.CachePolicy {
        return isNetworkReachable ?
            .reloadIgnoringCacheData:
            .returnCacheDataElseLoad
        
    }
    private var isNetworkReachable:Bool{
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}

extension Alamofire.SessionManager{
    @discardableResult
    open func requestWithoutCashe(
        _ url: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil)
        -> DataRequest
    {
        do {
            var urlRequest = try URLRequest(url: url, method: method, headers: headers)
            urlRequest.cachePolicy = .reloadIgnoringCacheData
            let encodedURLRequest = try encoding.encode(urlRequest, with: parameters)
            return request(encodedURLRequest)
        } catch {
            print(error)
            return request(URLRequest(url: URL(string: "http://example.com/wrong_request")!))
        }
    }
}

extension Alamofire.SessionManager{
    @discardableResult
    open func requestWithCachePolicy(
        _ url: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil,
        cachePolicy: URLRequest.CachePolicy)
        -> DataRequest
    {
        do {
            var urlRequest = try URLRequest(url: url, method: method, headers: headers)
            urlRequest.cachePolicy = cachePolicy
            let encodedURLRequest = try encoding.encode(urlRequest, with: parameters)
            return request(encodedURLRequest)
        } catch {
            Logger.log(error)
            return request(URLRequest(url: URL(string: "http://example.com/wrong_request")!))
        }
    }
}


//        return Alamofire
//            .request(
//                url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "",
//                method: method,
//                parameters: parameters,
//                encoding: encoding,
//                headers:headers
//            )
//            .rx
//            .mappable()

//            return HTTPManager.shared
//                .request(
//                    method,
//                    url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "",
//                    parameters: parameters
//                )
//            .debugLog()
//            .rx
//            .stringWithBodyInError()

//class HTTPManager: Alamofire.Manager {
//    static let shared: HTTPManager = {
//        let configuration = Timberjack.defaultSessionConfiguration()
//        let manager = HTTPManager(configuration: configuration)
//        return manager
//    }()
//}
