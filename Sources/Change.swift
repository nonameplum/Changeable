//
//  Change.swift
//  Changeable-iOS
//
//  Created by Łukasz Śliwiński on 19/11/2017.
//  Copyright © 2017 plum. All rights reserved.
//

import Foundation

public struct Change<T> {
    // MARK: - Properties
    public let value: T
    public let changedKeyPaths: Set<PartialKeyPath<T>>

    // MARK: - Initalization
    public init(value: T, changedKeyPaths: Set<PartialKeyPath<T>>) {
        self.value = value
        self.changedKeyPaths = changedKeyPaths
    }

    public init(value: T, changedKeyPaths: [PartialKeyPath<T>]) {
        self.init(value: value, changedKeyPaths: Set(changedKeyPaths))
    }

    // MARK: - Matching
    public func changeMatching<Value>(_ keyPath: KeyPath<T, Value>) -> Value? {
        return (changedKeyPaths as Set<AnyKeyPath>).matching(keyPath, on: value)
    }

    public static func ~=(pattern: Change<T>, predicate: Set<PartialKeyPath<T>>) -> Bool {
        return Set(predicate).isSubset(of: pattern.changedKeyPaths)
    }
}
