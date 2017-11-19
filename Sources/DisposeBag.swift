//
//  DisposeBag.swift
//  Changeable-iOS
//
//  Created by Łukasz Śliwiński on 19/11/2017.
//  Copyright © 2017 plum. All rights reserved.
//

import Foundation

public extension Disposable {
    /**
     Adds `self` to `bag`.

     - parameter bag: `DisposeBag` to add `self` to.
     */
    public func addDisposableTo(_ bag: DisposeBag) {
        bag.insert(self)
    }
}

public final class DisposeBag {

    // MARK: - Properties
    private var _lock = NSRecursiveLock()
    private var _disposables = [Disposable]()
    private var _isDisposed = false

    public init() {
        
    }

    // MARK: - Private
    private func _insert(_ disposable: Disposable) -> Disposable? {
        _lock.lock(); defer { _lock.unlock() }
        if _isDisposed {
            return disposable
        }

        _disposables.append(disposable)

        return nil
    }

    private func _dispose() -> [Disposable] {
        _lock.lock(); defer { _lock.unlock() }

        let disposables = _disposables

        _disposables.removeAll(keepingCapacity: false)
        _isDisposed = true

        return disposables
    }

    // MARK: - Public
    public func insert(_ disposable: Disposable) {
        _insert(disposable)?.dispose()
    }

    public func dispose() {
        let oldDisposables = _dispose()

        for disposable in oldDisposables {
            disposable.dispose()
        }
    }

    deinit {
        dispose()
    }
}
