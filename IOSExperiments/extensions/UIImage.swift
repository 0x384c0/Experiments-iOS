//
//  UIImage.swift
//  IOSExperiments
//
//  Created by Andrew Ashurov on 9/18/18.
//  Copyright © 2018 0x384c0. All rights reserved.
//

import Foundation

extension UIImage{
    func imageWithFillingSize(_ size:CGSize) -> UIImage {
        var scaledImageRect = CGRect.zero;
        
        let aspectWidth:CGFloat = size.width / self.size.width;
        let aspectHeight:CGFloat = size.height / self.size.height;
        let aspectRatio:CGFloat = max(aspectWidth, aspectHeight);
        
        scaledImageRect.size.width = self.size.width * aspectRatio;
        scaledImageRect.size.height = self.size.height * aspectRatio;
        scaledImageRect.origin.x = (size.width - scaledImageRect.size.width) / 2.0;
        scaledImageRect.origin.y = (size.height - scaledImageRect.size.height) / 2.0;
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0);
        
        self.draw(in: scaledImageRect);
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return scaledImage!;
    }
    
    
    static func aspectFit(size:CGSize, boundingSize: CGSize) -> CGSize {
        var boundingSize = boundingSize
        let mW = boundingSize.width / size.width;
        let mH = boundingSize.height / size.height;
        
        if( mH < mW ) {
            boundingSize.width = boundingSize.height / size.height * size.width;
        }
        else if( mW < mH ) {
            boundingSize.height = boundingSize.width / size.width * size.height;
        }
        return boundingSize
    }
}
