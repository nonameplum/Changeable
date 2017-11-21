<H1 align="center">Changeable</H1>
<H4 align="center">
Simple framework that allows to explicitly follow and observe changes made in an object/value.
</H4>
<p align="center">
<img alt="Changeable" src="Resources/Changeable.png" width="200" />
</p>
<p align="center">
<a href="https://developer.apple.com/swift"><img alt="Swift4" src="https://img.shields.io/badge/language-swift4-orange.svg?style=flat"/></a>
<a href="https://cocoapods.org/pods/Changeable"><img alt="CocoaPods" src="https://img.shields.io/cocoapods/v/Changeable.svg"/></a>
<a href="https://github.com/Carthage/Carthage"><img alt="Carthage" src="https://img.shields.io/badge/Carthage-compatible-yellow.svg?style=flat"/></a>
<a href="https://developer.apple.com/swift/"><img alt="Platform" src="https://img.shields.io/badge/platform-iOS%20%7C%20OSX%20%7C%20tvOS%20%7C%20watchOS-green.svg"/></a>
<a href="https://github.com/ra1028/VueFlux/blob/master/LICENSE"><img alt="Lincense" src="http://img.shields.io/badge/license-MIT-000000.svg?style=flat"/></a>
</p>

---

## About Changeable

`Changable` is a wrapper on an object regardless if it will be `class` or `struct` that can be changed using one exposed method `set`. What makes it different that normal set is that all of the changes made using `set` method won't be immediately applied but after using `commit` method. To fully cover needs `Changeable` also allows you to reset pending changes by `reset` method.

In addition `Changeable` gives you possibility to check current pending changes and last made changes. Also `Changeable` can be observed with changes that occurs during it's lifetime.

This gives the opportunity to react on specific state changes that you are interested in.

Example:

```swift
struct SomeState {
    var isLoading: Bool
    var counter: Int
}

let state = Changeable<SomeState>(value: SomeState(isLoading: false, counter: 0))

state.set(for: \SomeState.counter, value: 1)
print(state.pendingChanges.count) // 1
print(state.pendingChanges.contains(\SomeState.counter)) // true
state.commit()
print(state.value.counter) // 1

state.set(for: \SomeState.isLoading, value: true)
state.reset()
print(state.value.isLoading) // false

// Observer will be notifed once for every commit
// We can observe only changes that match keyPaths
let disposable = state.add(matching: [\SomeState.isLoading], observer: { change in
    if let isLoading = change.changeMatching(\SomeState.isLoading) {
        print("⏳ Loading: \(isLoading)")
    }

    if change ~= [\SomeState.isLoading] {
        print("Contains change isLoading")
    }

    if change.changedKeyPaths == [\SomeState.isLoading, \SomeState.counter] {
        // Sorry, no
    }
})

state.set(for: \SomeState.isLoading, value: true)
state.commit() // Observer called
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
    if change ~= Change<SomeState>.StateChange.loading.changesDefinition {
        print("Contains change isLoading")
    }
    // Or
    if change.changesEqual(to: .everything) {
        print("Everything has changed")
    }
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
```

More examples you will find in the playgound and in tests and in this [acrticle](https://medium.com/@sliwinski.lukas/changeable-follow-changes-with-keypaths-in-swift-4-e81d95c5d406).

---

## Requirements
- Swift 4.0 or later
- MacOS 10.9 or later
- iOS 8.0 or later
- watchOS 2.0 or later
- tvOS 9.0 or later

---

## Installation

### [CocoaPods](https://cocoapods.org/)  
Add the following to your Podfile:  
```ruby
use_frameworks!

target 'TargetName' do
  pod 'Changeable'
end
```
And run
```sh
pod install
```

### [Carthage](https://github.com/Carthage/Carthage)  
Add the following to your Cartfile:  
```ruby
github "nonameplum/Changeable"
```
And run
```sh
carthage update
```

---

## License
Changeable is released under the MIT License.  

---