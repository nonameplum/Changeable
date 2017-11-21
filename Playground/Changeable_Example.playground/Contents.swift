//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

import Changeable

struct SomeState {
    var isLoading: Bool
    var counter: Int
}

let state = Changeable<SomeState>(value: SomeState(isLoading: false, counter: 0))

state.set(for: \SomeState.counter, value: 1)
print("Changes count", state.pendingChanges.count)
print("Contains counter change", state.pendingChanges.contains(\SomeState.counter))
state.commit()
print("Counter value after commit", state.value.counter)

state.set(for: \SomeState.isLoading, value: true)
state.reset()
print("isLoading after reset", state.value.isLoading)

// Observer will be notifed once for every commit
// We can observe only changes that match keyPaths
let disposable = state.add(matching: [\SomeState.isLoading], observer: { change in
    print("// Observable 1 //")
    if let isLoading = change.changeMatching(\SomeState.isLoading) {
        print("⏳ Loading: \(isLoading)")
    }

    if change ~= [\SomeState.isLoading] {
        print("Contains change isLoading")
    }

    if change.changedKeyPaths == [\SomeState.isLoading, \SomeState.counter] {
        // Sorry, no
    }
    print("// Observable 1 end //")
})

state.set(for: \SomeState.isLoading, value: true)
state.commit()
disposable.dispose()

// We could define change cases that we are interested in
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

// We can also use diposeBag in the same way like RxSwift to handle more than one disposable in one place
var disposeBag: DisposeBag! = DisposeBag()
state.add(observer: { change in
    print("// Observable 2 //")
    if change ~= Change<SomeState>.StateChange.loading.changesDefinition {
        print("Contains change isLoading")
    }
    // Or
    if change.changesEqual(to: .everything) {
        print("Everything has changed")
    }
    print("// Observable 2 end //")
}).addDisposableTo(disposeBag)
state.set(for: \SomeState.counter, value: 2)
state.set(for: \SomeState.isLoading, value: false)
state.commit()
disposeBag = nil

// We can always check last changes
if let lastCounterValue = state.lastChangeMatching(\SomeState.counter) {
    print("Last changed counter value: \(lastCounterValue)")
}

if state.lastChanges.contains(\SomeState.isLoading) {
    print("The last changes contain loading change")
}
