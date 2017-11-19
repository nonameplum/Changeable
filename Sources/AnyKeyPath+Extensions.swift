//
//  AnyKeyPath+Extensions.swift
//  Changeable-iOS
//
//  Created by Łukasz Śliwiński on 19/11/2017.
//  Copyright © 2017 plum. All rights reserved.
//

import Foundation

public extension AnyKeyPath {

    public func matching<Root, Value>(_ keyPath: KeyPath<Root, Value>, on object: Any) -> Value? {
        if self == keyPath {
            if let value = object[keyPath: self] as? Value {
                return value
            }
        }
        return nil
    }
}

public extension Collection where Element == AnyKeyPath {

    public func matching<Root, Value>(_ keyPath: KeyPath<Root, Value>, on object: Any) -> Value? {
        return first(where: { (elem) -> Bool in
            return elem == keyPath
        })?.matching(keyPath, on: object)
    }
}
