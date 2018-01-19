//
//  GoogleService.swift
//  IOSExperiments
//
//  Created by Andrew Ashurow on 29.09.16.
//  Copyright © 2016 0x384c0. All rights reserved.
//

import RxSwift

protocol GoogleServiceProtocol{
    func searchImages(query: String, page: Int) -> Observable<ImagesResponseMappable>
    func loadApiList() -> Observable<ApiListResponse>
}

class GoogleService: BaseService, GoogleServiceProtocol {
    func searchImages(query: String, page: Int) -> Observable<ImagesResponseMappable> {
        return createRequest(
            url : Constants.GOOGLE_API_IMAGES_URL,
            parameters: [
                "q": query,
                "start": page,
                "alt": "json",
                "searchType": "image",
                "cx": Constants.GOOGLE_API_CX,
                "key": Constants.GOOGLE_API_KEY,
                ]
        )
    }
    
    func loadApiList() -> Observable<ApiListResponse>{
        return createRequest(
            url : "https://www.googleapis.com/discovery/v1/apis"
        )
    }
}


class GoogleServiceStub:BaseServiceStub, GoogleServiceProtocol {
    func searchImages(query: String, page: Int) -> Observable<ImagesResponseMappable> {
        return Observable.create{[weak self] observer -> Disposable in
            var data = [Item]()
            for i in 0...10 {
                data.append(Item(title: "Image id: \(i) page: \(page)", image: Image(thumbnailLink: "https://www.wired.com/wp-content/uploads/2015/09/google-logo-1200x630.jpg", contextLink: "https://www.wired.com/wp-content/uploads/2015/09/google-logo-1200x630.jpg")))
            }
            self?.sendData(observer, #function, ImagesResponseMappable(items: data))
            return Disposables.create()
        }
    }
    
    func loadApiList() -> Observable<ApiListResponse>{
        return Observable.create{[weak self] observer -> Disposable in
            self?.sendData(observer, #function, ApiListResponse())
            return Disposables.create()
        }
    }
}

