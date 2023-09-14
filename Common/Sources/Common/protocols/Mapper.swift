//
// Created on: 14/9/23

public protocol Mapper {
    associatedtype IN
    associatedtype OUT

    func map(input: IN) -> OUT
}
