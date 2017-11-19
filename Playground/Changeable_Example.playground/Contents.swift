//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

import Changeable

// Definitions

class SomeState {
    var isLoading: Bool = false
    var counter: Int = 0
}

extension Change where T == SomeState {

    enum StateChange {
        case everything
        case loading

        var changesDefinition: Set<PartialKeyPath<T>> {
            switch self {
            case .everything:
                return Set([\SomeState.counter, \SomeState.isLoading])
            case .loading:
                return Set([\SomeState.isLoading])
            }
        }
    }

    func changesEqual(to change: StateChange) -> Bool {
        return change.changesDefinition == changedKeyPaths
    }
}

// Example

let value = Changeable<SomeState>(value: SomeState())

value.add(observer: { (change) in
    if change.changesEqual(to: .everything) {
        print("🌕 Everything has changed")
    }

    if change.changesEqual(to: .loading) {
        print("⏳ Loading has changed")
    }

    if change ~= Change<SomeState>.StateChange.loading.changesDefinition {
        print("♦️ Contains loading")
    }

    if let counter = change.changeMatching(\SomeState.counter) {
        print("💯 Counter: \(counter)")
    }

    print("🎉 value did change: \(change.value)) 🔀 changes: \(change.changedKeyPaths)")
})

value.set(for: \SomeState.isLoading, value: false)
value.set(for: \SomeState.counter, value: 1)
value.commit()
print("Commit -------------------------")

value.set(for: \SomeState.counter, value: 2)
value.commit()
print("Commit -------------------------")

value.set(for: \SomeState.isLoading, value: true)
value.commit()
print("Commit -------------------------")

value.set(for: \SomeState.counter, value: 3)
print("pending changes: \(value.pendingChanges) count: \(value.pendingChanges.count)")
value.reset()
print("Reset --------------------------")
print("pending changes count: \(value.pendingChanges.count)")

if let lastCounterValue = value.lastChangeMatching(\SomeState.counter) {
    print("last changed counter value: \(lastCounterValue)")
}
