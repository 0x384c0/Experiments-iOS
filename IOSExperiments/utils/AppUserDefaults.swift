//
//  AppUserDefaults.swift
//  IOSExperiments
//
//  Created by 0x384c0 on 20.06.17.
//  Copyright © 2017 0x384c0. All rights reserved.
//


class AppUserDefaults {
    //MARK: RemoteFetch
    static var isRemoteFetchEnabed:Bool{
        get { return UserDefaults.standard.bool(forKey: "RemoteFetch._isRemoteFetchEnabed") }
        set { UserDefaults.standard.set(newValue, forKey: "RemoteFetch._isRemoteFetchEnabed") }
    }
    static var remoteFetchLog:String?{
        get { return UserDefaults.standard.string(forKey: "RemoteFetch._remoteFetchLog") }
        set { UserDefaults.standard.set(newValue, forKey: "RemoteFetch._remoteFetchLog") }
    }
    static var locationUpdatesLog:String?{
        get { return UserDefaults.standard.string(forKey: "RemoteFetch._locationUpdatesLog") }
        set { UserDefaults.standard.set(newValue, forKey: "RemoteFetch._locationUpdatesLog") }
    }
    static var locationUpdatesNetworkLog:String?{
        get { return UserDefaults.standard.string(forKey: "RemoteFetch._locationUpdatesNetworkLog") }
        set { UserDefaults.standard.set(newValue, forKey: "RemoteFetch._locationUpdatesNetworkLog") }
    }
}
