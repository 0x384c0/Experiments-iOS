//
//  TabModel.swift
//  IOSExperiments
//
//  Created by 0x384c0 on 12/25/15.
//  Copyright © 2015 0x384c0. All rights reserved.
//

class MainTabList {
    var tabs = [MainTab]()

    init() {

        var
        mainTab = MainTab()
        mainTab.title = "UI".localized

        var
        screen = Screen()
        screen.title = "Web View"
        screen.subTitle = "Web View"
        screen.screenId = "WebViewScreenController"
        mainTab.screens.append(screen)

        screen = Screen()
        screen.title = "Visulal effects"
        screen.subTitle = "Blur, Vibrancy, Scroll ivew"
        screen.screenId = "VisulalEffectsController"
        mainTab.screens.append(screen)

        screen = Screen()
        screen.title = "AVPlayer"
        screen.subTitle = "Live Streaming Audio Player"
        screen.screenId = "AVPlayerController"
        mainTab.screens.append(screen)

        tabs.append(mainTab)
        //-----------------------------------------------------------------------------


        mainTab = MainTab()
        mainTab.title = "RX".localized


        screen = Screen()
        screen.title = "Google Images"
        screen.subTitle = "rxAlamofire, MVVM, Google Api, Pagination"
        screen.screenId = "GoogleImagesViewController"
        mainTab.screens.append(screen)

        tabs.append(mainTab)
        //-----------------------------------------------------------------------------


        mainTab = MainTab()
        mainTab.title = "OTHERS".localized


        screen = Screen()
        screen.title = "Coming soon"
        screen.subTitle = "If I have time"
        mainTab.screens.append(screen)


        tabs.append(mainTab)
        //-----------------------------------------------------------------------------
    }
}


