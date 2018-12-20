//
//  MainViewModel.swift
//  IOSExperiments
//
//  Created by 0x384c0 on 12/28/15.
//  Copyright © 2015 0x384c0. All rights reserved.
//


import RxSwift

class MainViewModel {
    
    //MARK: UI Binding
    fileprivate var tabs:[MainTab]?
    var tabsBinding = PublishSubject<[MainTab]>()
    
    func loadTabs() {
        self.tabs = MainTabList().tabs
        tabsBinding.value = self.tabs!
    }
}
