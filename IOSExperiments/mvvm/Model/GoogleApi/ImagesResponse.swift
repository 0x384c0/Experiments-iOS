//
//  ImagesResponse.swift
//  IOSExperiments
//
//  Created by 0x384c0 on 12/1/15.
//  Copyright © 2015 0x384c0. All rights reserved.
//

import Foundation
import ObjectMapper

class ImagesResponseMappable: Mappable {
    var kind: String?
    var items: [Item]?
    
    //Mappable
    required init?(map: Map) { }
    func mapping(map: Map) {
        kind <- map["kind"]
        items <- map["items"]
    }
    //tests
    required init(items: [Item]?) {
        self.items = items
    }
}

class Item: Mappable {
    var kind: String?
    var title: String?
    var image: Image?
    
    //Mappable
    required init?(map: Map) { }
    func mapping(map: Map) {
        kind <- map["kind"]
        title <- map["title"]
        image <- map["image"]
    }
    //tests
    required init(title: String?,image: Image?) {
        self.title = title
        self.image = image
    }
}

class Image: Mappable {

    var thumbnailLink: String?
    var contextLink: String?
    
    //Mappable
    required init?(map: Map) { }
    func mapping(map: Map) {
        thumbnailLink <- map["thumbnailLink"]
        contextLink <- map["contextLink"]
    }
    //tests
    required init(thumbnailLink: String?,contextLink: String?) {
        self.thumbnailLink = thumbnailLink
        self.contextLink = contextLink
    }
}


class ApiListResponse:Mappable{
    var kind:String?
    //Mappable
    required init?(map: Map) { }
    func mapping(map: Map) {
        kind <- map["kind"]
    }
    //tests
    required init() {
        self.kind = "stub loaded"
    }
}
