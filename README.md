# Changeable


<H1 align="center">Changeable</H1>
<H4 align="center">
Simple framework that allows to explicitly follow and observe changes made in an object/value.
</H4>
</br>

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
class SomeState {
    var isLoading: Bool = false
    var counter: Int = 0
}

let value = Changeable<SomeState>(value: SomeState())

value.add(observer: { (change) in
    if change.changedKeyPaths == [\SomeState.isLoading] {
        print("⏳ Loading has changed")
    }
    
    if change ~= [\SomeState.counter] {
    	print("💯 Counter has changed")
    }
    
    if let counter = change.changeMatching(\SomeState.counter) {
        print("💯 Counter: \(counter)") // Output: 1
    }
})

value.set(for: \SomeState.isLoading, value: false)
value.set(for: \SomeState.counter, value: 1)
value.commit()

value.set(for: \SomeState.counter, value: 2)
value.reset()

if let lastCounterValue = value.lastChangeMatching(\SomeState.counter) {
    print("last changed counter value: \(lastCounterValue)") // Output: 1
}

if value.lastChanges.contains(\SomeState.isLoading) {
    print("The last changes contains loading change")
}
```

More examples you will find in the playgound and in tests.

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