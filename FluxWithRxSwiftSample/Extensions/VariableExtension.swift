//
//  VariableExtension.swift
//  FluxWithRxSwiftSample
//
//  Created by Yuji Hato on 2016/12/02.
//  Copyright © 2016年 dekatotoro. All rights reserved.
//

import RxSwift

extension Variable {
    func asShareReplayLatest() -> Observable<E> {
        return asObservable().shareReplayLatestWhileConnected()
    }
}
