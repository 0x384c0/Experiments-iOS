//
//  TextMessagesManager.swift
//  IOSExperiments
//
//  Created by 0x384c0 on 09.03.17.
//  Copyright © 2017 0x384c0. All rights reserved.
//

import SwiftMessages

class TextMessagesManager{
    private static var
    conf = SwiftMessages.Config(),
    isShown:Bool = false,
    listener:SwiftMessages.EventListener = {event in
        switch event{
        case .willShow:
            isShown = true
        case .didShow:
            isShown = true
        case .willHide:
            isShown = true
        case .didHide:
            isShown = false
        }
    }
    
    static func show(_ text:String?,_ presenterView:UIView){
        let view: CustomMessageView = try! SwiftMessages.viewFromNib()
        view.setup(text)
        conf.presentationContext = .view(presenterView)
        conf.eventListeners = [listener]
        conf.duration = SwiftMessages.Duration.seconds(seconds: 5)
        if isShown{
            SwiftMessages.hideAll()
            DispatchQueue.mainAfterMilisec(500) {
                SwiftMessages.show(config: conf, view: view)
            }
        } else {
            SwiftMessages.show(config: conf, view: view)
        }
    }
}
