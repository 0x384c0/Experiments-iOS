//
//  AppDelegate.swift
//  IOSExperiments
//
//  Created by 0x384c0 on 11/13/15.
//  Copyright © 2015 0x384c0. All rights reserved.
//

import UIKit
import GoogleMaps
import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        SVProgressHUD.setDefaultMaskType(.clear)
        GMSServices.provideAPIKey(Constants.GOOGLE_API_KEY)
        return true
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        RemoteFetchWrapper.performFetchWithCompletionHandler(completionHandler)
    }
}

