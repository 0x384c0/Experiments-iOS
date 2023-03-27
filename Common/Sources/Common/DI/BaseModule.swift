//
// Created on: 27/3/23

import Foundation

public protocol BaseModule {
    func register() -> BaseModule
}

public extension BaseModule {
    func initialize() {
    }
}
