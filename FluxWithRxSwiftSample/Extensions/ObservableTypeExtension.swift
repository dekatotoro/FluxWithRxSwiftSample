//
//  ObservableTypeExtension.swift
//  FluxWithRxSwiftSample
//
//  Created by Yuji Hato on 2016/10/13.
//  Copyright © 2016年 dekatotoro. All rights reserved.
//

import RxSwift

/// Protocol type for Optionals.
/// Used for extensions to protocols with associated types.
/// Can restrict the extension to only when the associated tye is Optional
protocol OptionalType {
    associatedtype Wrapped
    
    var value: Wrapped? { get }
}

extension Optional: OptionalType {
    var value: Wrapped? { return self }
}


extension ObservableType {
    
    func map<T>(_ variable: Variable<T>) -> Observable<T> {
        return map { _ in variable.value }
    }
    
    func then<T>(_ observable: Observable<T>) -> Observable<T> {
        return flatMap { _ in observable }
    }
    
    func then<T>(_ closure: @escaping ((Void) -> Observable<T>)) -> Observable<T> {
        return flatMap { _ in closure() }
    }
    
    func mapToOptional() -> Observable<Optional<E>> {
        return map { Optional($0) }
    }
    
}

// MARK: ObservableType where E: OptionalType
// Observable<E>のEがOptionalだった場合
extension ObservableType where E: OptionalType {
    
    /// Filters out the nil elements of a sequence of optional elements
    /// - returns: An observable sequence of only the non-nil elements
    func filterNil() -> Observable<E.Wrapped> {
        return flatMap { item -> Observable<E.Wrapped> in
            if let value = item.value {
                return Observable.just(value)
            } else {
                return Observable.empty()
            }
        }
    }
    
}

// MARK: ObservableType where E: CollectionType
extension ObservableType where E: Collection {
    
    /// Filters out elements of a sequence that are empty
    /// - returns: An observable sequence with only non-empty Collections
    func filterEmpty() -> Observable<E> {
        return filter { !$0.isEmpty }
    }
    
}
