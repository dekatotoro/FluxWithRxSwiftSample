//
//  SearchUserStore.swift
//  FluxWithRxSwiftSample
//
//  Created by Yuji Hato on 2016/10/13.
//  Copyright © 2016年 dekatotoro. All rights reserved.
//

import RxSwift

class SearchUserStore: Store {
    static let shared = SearchUserStore()
    
    fileprivate let searchUser = Variable<SearchModel<GitHubUser>>(SearchModel())
    fileprivate let loading = Variable<Bool>(false)
    fileprivate let error = PublishSubject<Error>()
    fileprivate let contentOffset = Variable<CGPoint>(.zero)
    fileprivate let scrollViewDidEndDragging = PublishSubject<Bool>()
    
    // shared variables
    fileprivate lazy var sharedSearchUser: Observable<SearchModel<GitHubUser>> = self.searchUser.asShareReplayLatest()
    fileprivate lazy var sharedLoading: Observable<Bool> = self.loading.asShareReplayLatest()
    fileprivate lazy var sharedContentOffset: Observable<CGPoint> = self.contentOffset.asShareReplayLatest()
    
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
    
    var searchUser: Observable<SearchModel<GitHubUser>> {
        return base.sharedSearchUser
    }
    var loading: Observable<Bool> {
        return base.sharedLoading
    }
    var error: Observable<Error> {
        return base.error
    }
    var contentOffset: Observable<CGPoint> {
        return base.sharedContentOffset
    }
    var scrollViewDidEndDragging: Observable<Bool> {
        return base.scrollViewDidEndDragging
    }
}

extension StoreVariable where Base: SearchUserStore {
    
    var searchUser: SearchModel<GitHubUser> {
        return base.searchUser.value
    }
    var loading: Bool {
        return base.loading.value
    }
    var contentOffset: CGPoint {
        return base.contentOffset.value
    }
}
