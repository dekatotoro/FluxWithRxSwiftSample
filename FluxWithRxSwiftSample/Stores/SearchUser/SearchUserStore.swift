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
    
    fileprivate let searchUser = Variable<SearchModel<GitHubUser>>(SearchModel())
    fileprivate let loading = Variable<Bool>(false)
    fileprivate let error = PublishSubject<Error>()
    fileprivate let contentOffset = Variable<CGPoint>(.zero)
    fileprivate let scrollViewDidEndDragging = PublishSubject<Bool>()
    
    init(dispatcher: SearchUserDispatcher = .shared) {
        super.init()
        
        bind(dispatcher.loading, loading)
        bind(dispatcher.error, error)
        
        dispatcher.searchUser.asObservable()
            .subscribe(onNext: { [unowned self] page, searchUser in
                if page == 0 {
                    self.searchUser.value = searchUser
                } else {
                    self.searchUser.value = self.searchUser.value.concat(searchModel: searchUser)
                }
            })
        .addDisposableTo(disposeBag)
        bind(dispatcher.contentOffset, contentOffset)
        
        bind(dispatcher.scrollViewDidEndDragging, scrollViewDidEndDragging)
    }
}

extension Reactive where Base: SearchUserStore {
    
    var searchUser: Variable<SearchModel<GitHubUser>> {
        return base.searchUser
    }
    
    var loading: Variable<Bool> {
        return base.loading
    }
    
    var error: PublishSubject<Error> {
        return base.error
    }
    
    var contentOffset: Variable<CGPoint> {
        return base.contentOffset
    }
    
    var scrollViewDidEndDragging: PublishSubject<Bool> {
        return base.scrollViewDidEndDragging
    }
}
