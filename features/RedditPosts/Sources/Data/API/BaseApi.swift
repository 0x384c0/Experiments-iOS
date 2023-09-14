//
// Created on: 14/9/23

import Foundation
import Combine
import Alamofire

public protocol BaseApi {
    var baseUrl: String { get }
}

public extension BaseApi {
    func createRequest<T: Decodable>(
        path: String,
        parameters: [String: Any]? = nil
    ) -> AnyPublisher<T, Error>{
        print("\(HTTPMethod.get) \(baseUrl + path) \(parameters ?? [:])")
        return AF.request(baseUrl + path)
            .validate()
            .publishDecodable(type: T.self)
            .value()
            .mapError { afError in
                afError as Error
            }
            .eraseToAnyPublisher()
    }

    func createRequestArray<T: Decodable>(
        path: String,
        parameters: [String: Any]? = nil
    ) -> AnyPublisher<[T], Error>{
        print("\(HTTPMethod.get) \(baseUrl + path) \(parameters ?? [:])")
        return AF.request(baseUrl + path)
            .validate()
            .publishDecodable(type: [T].self)
            .value()
            .mapError { afError in
                afError as Error
            }
            .eraseToAnyPublisher()
    }
}
