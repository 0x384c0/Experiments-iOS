//
//  DispatchQueue.swift
//  IOSExperiments
//
//  Created by 0x384c0 on 06.01.17.
//  Copyright © 2017 0x384c0. All rights reserved.
//

extension DispatchQueue{
    static func mainAfterMilisec(_ milliseconds:Int,execute work: @escaping @convention(block) () -> Swift.Void){
        DispatchQueue.main.asyncAfter(deadline:  (DispatchTime.now() + .milliseconds(milliseconds)), execute: work)
    }
}
