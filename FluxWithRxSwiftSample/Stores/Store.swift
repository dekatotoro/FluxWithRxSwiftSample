//
//  Store.swift
//  FluxWithRxSwiftSample
//
//  Created by Yuji Hato on 2016/10/13.
//  Copyright © 2016年 dekatotoro. All rights reserved.
//

import RxSwift

struct StoreVariable<Base> {
    let base: Base
    
    public init(_ base: Base) {
        self.base = base
    }
}

protocol StoreVariableCompatible {
    associatedtype CompatibleType
    
    var sv: StoreVariable<CompatibleType> { get set }
}

extension StoreVariableCompatible {
    var sv: StoreVariable<Self> {
        get {
            return StoreVariable(self)
        }
        set {
            // this enables using AnyVariable to "mutate" base object
        }
    }
}

class Store: ReactiveCompatible, StoreVariableCompatible {
    
    let disposeBag = DisposeBag()
    
    func bind<O, E>(_ observable: O, _ param: Variable<E>) where O: ObservableType, E == O.E {
        observable.bindTo(param).addDisposableTo(disposeBag)
    }
    
    func bind<O, E>(_ observable: O, _ param: PublishSubject<E>) where O: ObservableType, E == O.E {
        observable.bindTo(param).addDisposableTo(disposeBag)
    }
}


