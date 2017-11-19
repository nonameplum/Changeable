//
//  ChangeableTests.swift
//  plum
//
//  Created by Łukasz Śliwiński on 19/11/2017.
//  Copyright © 2017 plum. All rights reserved.
//

import Foundation
import XCTest
import Changeable

class ChangeableTests: XCTestCase {

    class TestClass {
        var isLoading: Bool = false
        var counter: Int = 0
    }

    class TestStruct {
        var isLoading: Bool = false
        var counter: Int = 0
    }

    var changeableClass = Changeable(value: TestClass())
    var changeableStruct = Changeable(value: TestStruct())

    override func setUp() {
        changeableClass = Changeable(value: TestClass())
        changeableStruct = Changeable(value: TestStruct())
    }

    func testClassSet() {
        changeableClass.set(for: \TestClass.isLoading, value: true)
        changeableClass.set(for: \TestClass.counter, value: 1)
        changeableClass.commit()

        XCTAssertTrue(changeableClass.value.isLoading == true)
        XCTAssertTrue(changeableClass.value.counter == 1)
    }

    func testStructSet() {
        changeableStruct.set(for: \TestStruct.isLoading, value: true)
        changeableStruct.set(for: \TestStruct.counter, value: 1)
        changeableStruct.commit()

        XCTAssertTrue(changeableStruct.value.isLoading == true)
        XCTAssertTrue(changeableStruct.value.counter == 1)
    }

    func testPendingChanges() {
        changeableStruct.set(for: \TestStruct.counter, value: 1)
        changeableStruct.set(for: \TestStruct.counter, value: 2)
        changeableStruct.set(for: \TestStruct.isLoading, value: true)
        XCTAssertTrue(changeableStruct.pendingChanges.count == 2)
    }

    func testReset() {
        changeableStruct.set(for: \TestStruct.counter, value: 2)
        changeableStruct.set(for: \TestStruct.isLoading, value: true)
        XCTAssertTrue(changeableStruct.pendingChanges.count == 2)
        changeableStruct.reset()
        XCTAssertTrue(changeableStruct.pendingChanges.count == 0)
    }

    func testValueOverride() {
        changeableStruct.set(for: \TestStruct.counter, value: 1)
        changeableStruct.set(for: \TestStruct.counter, value: 2)
        changeableStruct.commit()
        XCTAssertTrue(changeableStruct.value.counter == 2)
    }

    func testPendingChangesKeyPaths() {
        XCTAssertTrue(changeableStruct.pendingChanges.count == 0)
        changeableStruct.set(for: \TestStruct.counter, value: 1)
        XCTAssertTrue(changeableStruct.pendingChanges == Set([\TestStruct.counter]))
        changeableStruct.set(for: \TestStruct.isLoading, value: true)
        XCTAssertTrue(changeableStruct.pendingChanges == Set([\TestStruct.counter, \TestStruct.isLoading]))
    }

    func testObservable() {
        let exp = expectation(description: "observe changes")

        let disposeBag = DisposeBag()
        changeableStruct.add(observer: { change in
            XCTAssertTrue(change.changedKeyPaths == Set([\TestStruct.counter]))
            XCTAssertTrue(change.value.counter == 1)
            XCTAssertTrue(change.value.isLoading == false)
            exp.fulfill()
        }).addDisposableTo(disposeBag)

        changeableStruct.set(for: \TestStruct.counter, value: 1)
        changeableStruct.commit()

        wait(for: [exp], timeout: 2)
    }

    func testObservalbeMatching_Success() {
        let exp = expectation(description: "obseve changes matching")

        let disposeBag = DisposeBag()
        changeableStruct.add(matching: [\TestStruct.counter], observer: { change in
            XCTAssertTrue(change.changedKeyPaths == [\TestStruct.counter])
            exp.fulfill()
        }).addDisposableTo(disposeBag)

        changeableStruct.set(for: \TestStruct.counter, value: 1)
        changeableStruct.commit()

        wait(for: [exp], timeout: 2)
    }

    func testObservalbeMatching_Failure() {
        let exp = expectation(description: "obseve changes not matching")

        let disposeBag = DisposeBag()
        changeableStruct.add(matching: [\TestStruct.counter], observer: { change in
            XCTAssertTrue(change.changedKeyPaths != [\TestStruct.counter])
            exp.fulfill()
        }).addDisposableTo(disposeBag)

        changeableStruct.set(for: \TestStruct.counter, value: 1)
        changeableStruct.set(for: \TestStruct.isLoading, value: true)
        changeableStruct.commit()

        wait(for: [exp], timeout: 2)
    }

    func testObservableMemoryLeak() {
        var disposeBag: DisposeBag! = DisposeBag()

        let disposable = changeableStruct.add(observer: { _ in })
        disposeBag.insert(disposable)
        
        disposeBag = nil
        print(disposeBag)
        XCTAssertTrue(disposeBag == nil)
    }

    func testLastChanges() {
        changeableStruct.set(for: \TestStruct.counter, value: 1)
        changeableStruct.commit()
        XCTAssertTrue(changeableStruct.lastChanges == Set([\TestStruct.counter]))

        changeableStruct.reset()
        XCTAssertTrue(changeableStruct.lastChanges == Set([\TestStruct.counter]))

        changeableStruct.set(for: \TestStruct.counter, value: 2)
        changeableStruct.set(for: \TestStruct.isLoading, value: true)
        changeableStruct.commit()
        XCTAssertTrue(changeableStruct.lastChanges == Set([\TestStruct.counter, \TestStruct.isLoading]))
    }

    func testLastChangeMatching() {
        changeableStruct.set(for: \TestStruct.counter, value: 1)
        changeableStruct.commit()

        if let counter = changeableStruct.lastChangeMatching(\TestStruct.counter) {
            XCTAssertTrue(counter == 1)
        } else {
            XCTFail("Coun't get counter value from last changes")
        }

        XCTAssertTrue(changeableStruct.lastChangeMatching(\TestStruct.isLoading) == nil)
    }
}
