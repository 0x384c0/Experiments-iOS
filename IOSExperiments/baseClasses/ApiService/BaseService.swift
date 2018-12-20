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
    func createRequest<T:Mappable>(//json with object as root
        url:String,
        parameters: [String: Any]? = nil,
        headers: HTTPHeaders? = nil,
        method: HTTPMethod = .get,
        encoding: ParameterEncoding = URLEncoding.default) -> Observable<T>{
        Logger.logRequest(url: url, parameters: parameters, headers: headers, method: method)
        
        return Alamofire.SessionManager.default.request(
            url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "",
            method: method,
            parameters: parameters,
            encoding: encoding,
            headers: headers)
            .rx
            .mappable()
    }
    func createRequest<T:Mappable>(//json with array as root
        url:String,
        parameters: [String: Any]? = nil,
        headers: HTTPHeaders? = nil,
        method: HTTPMethod = .get,
        encoding: ParameterEncoding = URLEncoding.default) -> Observable<[T]>{
        Logger.logRequest(url: url, parameters: parameters, headers: headers, method: method)
        
        return Alamofire.SessionManager.default.request(
            url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "",
            method: method,
            parameters: parameters,
            encoding: encoding,
            headers: headers)
            .rx
            .mappableArray()
    }
    
    func createRequest<T:Mappable>(data:Data,url:String) -> Observable<T>{//upload Data
        Logger.logRequest(url: url, parameters: ["data" : String(describing: data)], headers: nil)
        return Alamofire.upload(
            data,
            to: url)
            .rx
            .mappable()
    }
    func createRequest<T:Mappable>(fileUrl:URL,url:String) -> Observable<T>{//upload file from path
        Logger.logRequest(url: url, parameters: ["fileUrl" : fileUrl.absoluteString], headers: nil)
        return Alamofire.upload(
            fileUrl,
            to: url)
            .rx
            .mappable()
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
            return request(URLRequest(url: URL(string: "http://example.com/wrong_request")!))
        }
    }
}
