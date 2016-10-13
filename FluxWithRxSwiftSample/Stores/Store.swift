//
//  Store.swift
//  FluxWithRxSwiftSample
//
//  Created by Yuji Hato on 2016/10/13.
//  Copyright © 2016年 dekatotoro. All rights reserved.
//

import RxSwift

class Store {
    
    let disposeBag = DisposeBag()
    
    func bind<O, E>(_ observable: O, _ param: Variable<E>) where O: ObservableType, E == O.E {
        observable.bindTo(param).addDisposableTo(disposeBag)
    }
    
    func bind<O, E>(_ observable: O, _ param: PublishSubject<E>) where O: ObservableType, E == O.E {
        observable.bindTo(param).addDisposableTo(disposeBag)
    }
}
