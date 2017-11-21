//
//  Disposable.swift
//  Changeable-iOS
//
//  Created by Łukasz Śliwiński on 19/11/2017.
//  Copyright © 2017 plum. All rights reserved.
//

import Foundation

public final class Disposable {

    // MARK: - Properties
    private let disposeAction: () -> Void
    private var _disposed: Bool = false
    private var _lock = NSRecursiveLock()

    // MARK: - Initalization
    init(_ dispose: @escaping () -> Void) {
        self.disposeAction = dispose
    }

    deinit {
        dispose()
    }

    // MARK: - Dispose
    public func dispose() {
        _lock.lock(); defer { _lock.unlock() }
        if _disposed { return }
        disposeAction()
        _disposed = true
    }
}
