//
//  ChangeObserver.swift
//  Changeable-iOS
//
//  Created by Łukasz Śliwiński on 19/11/2017.
//  Copyright © 2017 plum. All rights reserved.
//

import Foundation

struct ChangeObserver<T> {
    // MARK: - Properties
    let closure: (Change<T>) -> Void
    let query: [Int]?

    // MARK: - Initialization
    init(closure: @escaping (Change<T>) -> Void, query: [Int]?) {
        self.closure = closure
        self.query = query
    }
}
