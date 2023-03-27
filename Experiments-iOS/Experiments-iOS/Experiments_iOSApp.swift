//
//  Experiments_iOSApp.swift
//  Experiments-iOS
//
//  Created by 0x384c0 on 27/3/23.
//

import SwiftUI
import FeaturesHostPresentation

@main
struct Experiments_iOSApp: App, ModuleInitializer {
    var modules = [Any]()

    init(){
        initModules()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
