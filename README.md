FluxWithRxSwiftSample
========================

[![Platform](http://img.shields.io/badge/platform-ios-blue.svg?style=flat
)](https://developer.apple.com/iphone/index.action)
[![Language](http://img.shields.io/badge/language-swift-brightgreen.svg?style=flat
)](https://developer.apple.com/swift)
[![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat
)](http://mit-license.org)
[![Issues](https://img.shields.io/github/issues/dekatotoro/FluxWithRxSwiftSample.svg?style=flat
)](https://github.com/dekatotoro/FluxWithRxSwiftSample/issues?state=open)



This is a sample that was implemented the Flux Architecture using RxSwift in iOS.


[Flux Architecture](https://facebook.github.io/flux/)

[RxSwift](https://github.com/ReactiveX/RxSwift)


#### It is a simple application that the user search of github.

![sample](Screenshots/screenshots.gif)

## Setup
#### Pod setup
```
pod install
```

#### API token setup

You can get personal api token for github and set token to `Config.swift`
```swift
apiToken = "your api token"
```


##### see more information

[GitHub API Tokens](https://github.com/blog/1509-personal-api-tokens)

[GitHub API Reference](https://developer.github.com/v3/)


Warning: you can make up to 30 requests per minute

[search rate limit](https://developer.github.com/v3/search/#rate-limit)



## Requirements
Requires Swift3.0 and Xcode8 and iOS 9.0 or later.  



## Contributing
Forks, feedback are welcome.



## Creator
[Yuji Hato](https://github.com/dekatotoro)
[Blog](http://buzzmemo.blogspot.jp/)



## License
FluxWithRxSwiftSample is available under the MIT license. See the [LICENSE](./LICENSE) file for more info.
