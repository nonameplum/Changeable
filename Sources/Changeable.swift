//
//  Changeable.swift
//  plum
//
//  Created by Łukasz Śliwiński on 19/11/2017.
//  Copyright © 2017 plum. All rights reserved.
//

import Foundation

open class Changeable<T> {
    // MARK: - Properties
    // MARK: - Public
    public private(set) var value: T
    public private(set) var lastChanges: Set<PartialKeyPath<T>> = Set()
    public private(set) var pendingChanges: Set<PartialKeyPath<T>> = Set()
    // MARK: Private
    private var pendingAppliers: [Int: () -> Void] = [:]
    private var uniqueID = (0...).makeIterator()
    private var observers: [Int: ChangeObserver<T>] = [:]

    // MARK: - Initialization
    public init(value: T) {
        self.value = value
    }

    // MARK: - Private helpers
    private func clear() {
        pendingAppliers.removeAll()
        pendingChanges.removeAll()
    }

    // MARK: - Public
    // MARK: Observation
    public func add(matching keyPaths: [PartialKeyPath<T>]? = nil, observer: @escaping (Change<T>) -> Void) -> Disposable {
        guard let id = uniqueID.next() else { fatalError() }

        observers[id] = ChangeObserver(closure: observer, query: keyPaths?.flatMap({ $0.hashValue }))

        let disposable = Disposable { [weak self] in
            self?.observers.removeValue(forKey: id)
        }

        return disposable
    }

    // MARK: Changes
    public func set<V>(for keyPath: WritableKeyPath<T, V>, value: V) {
        pendingChanges.insert(keyPath)
        pendingAppliers[keyPath.hashValue] = { [weak self] in
            self?.value[keyPath: keyPath] = value
        }
    }

    public func commit() {
        pendingAppliers.forEach({ $0.value() })
        let change = Change(value: value, changedKeyPaths: self.pendingChanges)
        observers
            .filter({ (key, observer) -> Bool in
                guard let queryKeyPathHashes = observer.query else { return true }
                for hash in queryKeyPathHashes {
                    if pendingAppliers[hash] == nil {
                        return false
                    }
                }
                return true
            })
            .forEach({
                $0.value.closure(change)
            })
        lastChanges = pendingChanges
        clear()
    }

    public func reset() {
        clear()
    }

    public func lastChangeMatching<Value>(_ keyPath: KeyPath<T, Value>) -> Value? {
        return (lastChanges as Set<AnyKeyPath>).matching(keyPath, on: value)
    }
}
