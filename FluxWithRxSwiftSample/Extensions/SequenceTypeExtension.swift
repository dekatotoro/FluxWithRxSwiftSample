//
//  SequenceTypeExtensions.swift
//  FluxWithRxSwiftSample
//
//  Created by Yuji Hato on 2016/12/02.
//  Copyright © 2016年 dekatotoro. All rights reserved.
//

extension Sequence {
    /// Return first matched element index
    func find(_ includedElement: (Iterator.Element) -> Bool) -> Int? {
        for (index, element) in enumerated() {
            if includedElement(element) {
                return index
            }
        }
        return nil
    }
    
    func findItem(_ includedElement: (Iterator.Element) -> Bool) -> Iterator.Element? {
        for item in self where includedElement(item) {
            return item
        }
        return nil
    }
    
}

extension Sequence where Iterator.Element: OptionalType {
    
    /// Return not nil elements
    func filterNil() -> [Iterator.Element.Wrapped] {
        return flatMap { $0.value }
    }
    
}


extension Sequence where Iterator.Element: Hashable {
    
    typealias E = Iterator.Element
    
    func diff(other: [E]) -> [E] {
        let all = self + other
        var counter: [E: Int] = [:]
        all.forEach { counter[$0] = (counter[$0] ?? 0) + 1 }
        return all.filter { (counter[$0] ?? 0) == 1 }
    }
}


