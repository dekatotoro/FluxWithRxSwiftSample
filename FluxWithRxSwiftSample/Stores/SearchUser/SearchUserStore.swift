//
//  SearchUserStore.swift
//  FluxWithRxSwiftSample
//
//  Created by Yuji Hato on 2016/10/13.
//  Copyright © 2016年 dekatotoro. All rights reserved.
//

import RxSwift

class SearchUserStore: Store, ReactiveCompatible {
    static let shared = SearchUserStore()
    
    fileprivate let searchUser = Variable<SearchUser>(SearchUser())
    fileprivate let loading = Variable<Bool>(false)
    fileprivate let error = PublishSubject<Error>()
    
    init(dispatcher: SearchUserDispatcher = .shared) {
        super.init()
        
        bind(dispatcher.loading, loading)
        bind(dispatcher.error, error)
        bind(dispatcher.searchUser, searchUser)
    }
}

extension Reactive where Base: SearchUserStore {
    
    var searchUser: Variable<SearchUser> {
        return base.searchUser
    }
    
    var loading: Variable<Bool> {
        return base.loading
    }
    
    var error: PublishSubject<Error> {
        return base.error
    }
}
