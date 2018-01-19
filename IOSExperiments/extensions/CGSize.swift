//
//  CGSize.swift
//  IOSExperiments
//
//  Created by 0x384c0 on 06.03.17.
//  Copyright © 2017 0x384c0. All rights reserved.
//

extension CGSize {
    func aspectFit(boundingSize: CGSize) -> CGSize {
        var boundingSize = boundingSize
        let mW = boundingSize.width / width;
        let mH = boundingSize.height / height;
        
        if( mH < mW ) {
            boundingSize.width = boundingSize.height / height * width;
        }
        else if( mW < mH ) {
            boundingSize.height = boundingSize.width / width * height;
        }
        return boundingSize
    }
}
