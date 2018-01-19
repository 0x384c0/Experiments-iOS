//
//  Notifications.swift
//  iosExperiments
//
//  Created by 0x384c0 on 3/7/16.
//  Copyright © 2016 0x384c0. All rights reserved.
//

import Foundation
import SimplifiedNotificationCenter
/**
 для subscribe нужно обязательно хранить экземпляр класса Notifications, иначе подписка на Notification проебется вместе c Notifications
 для post это не нужно. Например: Notifications().refreshProfileVC.post(true)
 */
class Notifications {
    var
    boolNot = SimpleNotification<Bool>(name: "REFRESH_PROFILE_VC"),
    stringNot   = SimpleNotification<String>(name: "LANGUAGE_WILL_CHANGE")
    
}

