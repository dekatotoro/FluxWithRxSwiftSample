//
//  Dispatchers.swift
//  FluxWithRxSwiftSample
//
//  Created by Yuji Hato on 2016/10/13.
//  Copyright © 2016年 dekatotoro. All rights reserved.
//

import RxSwift

class DispatchSubject<Element>: ObservableType, ObserverType {
    typealias E = Element
    fileprivate let subject = PublishSubject<Element>()
    
    init() {}
    
    func dispatch(_ value: Element) {
        on(.next(value))
    }
    
    
    func subscribe<O: ObserverType>(_ observer: O) -> Disposable where O.E == E {
        return subject.subscribe(observer)
    }
    
    func on(_ event: Event<E>) {
        subject.on(event)
    }
}

