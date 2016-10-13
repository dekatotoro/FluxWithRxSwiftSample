# NavigationNotice

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Version](https://img.shields.io/cocoapods/v/NavigationNotice.svg?style=flat)](http://cocoadocs.org/docsets/NavigationNotice)
[![License](https://img.shields.io/cocoapods/l/NavigationNotice.svg?style=flat)](http://cocoadocs.org/docsets/NavigationNotice)
[![Platform](https://img.shields.io/cocoapods/p/NavigationNotice.svg?style=flat)](http://cocoadocs.org/docsets/NavigationNotice)

Customizable and interactive animated notification UI control.  
Easy to write at chainable syntax.

#### [Appetize's Demo](https://appetize.io/app/pdyqqg01mq9qutk9xf52bk3p8w)

![Notice](https://github.com/KyoheiG3/assets/blob/master/NavigationNotice/notice.gif)

## Requirements

- Swift 3.0
- iOS 7.0 or later

## How to Install NavigationNotice

### iOS 8+

#### CocoaPods

Add the following to your `Podfile`:

```Ruby
pod "NavigationNotice"
use_frameworks!
```
Note: the `use_frameworks!` is required for pods made in Swift.

#### Carthage

Add the following to your `Cartfile`:

```Ruby
github "KyoheiG3/NavigationNotice"
```

### iOS 7

Just add everything in the `NavigationNotice.swift` file to your project.

## Usage

### import

If target is ios8.0 or later, please import the `NavigationNotice`.

```swift
import NavigationNotice
```

### Example

Show simply notification.

```swift
let noticeView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 64))
NavigationNotice.addContent(noticeView).showOn(self.view).hide(2)
```
* Automatically set `width`.
* `height` of notification is same as `height` of the content.
* Hide at 2 sec from displayed in this example.

Set status bar hidden and animated block.

```swift
let noticeView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 64))
NavigationNotice.addContent(noticeView).showOn(self.view).showAnimations { animations, completion in
    UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.1, options: .BeginFromCurrentState, animations: animations, completion: completion)
} .hideAnimations { animations, completion in
    UIView.animateWithDuration(0.8, animations: animations, completion: completion)
}
```
* Not hidden status bar.
* Custome show and hide animation.

### Variable

```swift
class var defaultShowAnimations: ((() -> Void, (Bool) -> Void) -> Void)?
```
* Common animated block of show.
* Default is `nil`.

```swift
class var defaultHideAnimations: ((() -> Void, (Bool) -> Void) -> Void)?
```
* Common animated block of hide.
* Default is `nil`.

### Function

```swift
class func currentNotice() -> NavigationNotice.NavigationNotice?
```
* Return `NavigationNotice` optional instance that is currently displayed.

```swift
class func addContent(view: UIView) -> NavigationNotice.NavigationNotice
```
* Add content to display.
* Return `NavigationNotice` instance.

```swift
class func onStatusBar(on: Bool) -> NavigationNotice
```
* Set on the status bar of notification.
* Return `NavigationNotice` instance.

```swift
func completion(completion: (() -> Void)?)
```
* Completion handler.

```swift
func addContent(view: UIView) -> Self
```
* Add content to display.
* Return `Self` instance.

```swift
func showOn(view: UIView) -> Self
```
* Show notification on view.
* Return `Self` instance.

```swift
func showAnimations(animations: (() -> Void, (Bool) -> Void) -> Void) -> Self
```
* Animated block of show.
* Return `Self` instance.

```swift
func hideAnimations(animations: (() -> Void, (Bool) -> Void) -> Void) -> Self
```
* Animated block of hide.
* Return `Self` instance.

```swift
func hide(interval: NSTimeInterval) -> Self
```
* Hide notification.
* Return `Self` instance.

```swift
func removeAll(hidden: Bool) -> Self
```
* Remove all notification.
* Return `Self` instance.

## LICENSE

Under the MIT license. See LICENSE file for details.
