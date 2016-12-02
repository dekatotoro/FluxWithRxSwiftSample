//
//  DriverExtension.swift
//  FluxWithRxSwiftSample
//
//  Created by Yuji Hato on 2016/12/02.
//  Copyright © 2016年 dekatotoro. All rights reserved.
//

import RxCocoa

//// MARK: Driver where E: OptionalType
//// Driver<E>のEがOptionalだった場合
extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy, E: OptionalType {
    // Filters out the nil elements of a sequence of optional elements
    // - returns: An observable sequence of only the non-nil elements
    func filterNil() -> Driver<E.Wrapped> {
        return flatMap { (item) -> Driver<E.Wrapped> in
            if let value = item.value {
                return .just(value)
            } else {
                return .empty()
            }
        }
    }
}

// MARK: Driver where E: CollectionType
extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy, E: Collection {
    /// Filters out elements of a sequence that are empty
    /// - returns: An sequence driver with only non-empty Collections
    func filterEmpty() -> Driver<E> {
        return filter { !$0.isEmpty }
    }
}
