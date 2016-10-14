//
//  SearchUserAction.swift
//  FluxWithRxSwiftSample
//
//  Created by Yuji Hato on 2016/10/13.
//  Copyright © 2016年 dekatotoro. All rights reserved.
//

import RxSwift

class SearchUserAction {
    
    static let shared = SearchUserAction()
    
    private let dispatcher: SearchUserDispatcher
    private let store: SearchUserStore
    private let disposeBag = DisposeBag()
    
    init(dispatcher: SearchUserDispatcher = .shared,
         store: SearchUserStore = .shared) {
        self.dispatcher = dispatcher
        self.store = store
    }
    
    func loading(_ value: Bool) {
        self.dispatcher.loading.dispatch(value)
    }
    

    func searchUser(query: String, page: Int) {
        // before the request, the task in the request cancel
        GitHubAPI.cancelSearchUser()
        
        dispatcher.loading.dispatch(true)
        
        if query.isEmpty {
            dispatcher.searchUser.dispatch(SearchUser())
            dispatcher.loading.dispatch(false)
            return
        }
        
        let params = ["q" : query,
                      "page" : page,
                      "per_page" : 30] as [String : Any]
        GitHubAPI.searchUser(with: params)
            .do(onError: { [unowned self] error in
                self.dispatcher.error.dispatch(error)
                self.dispatcher.loading.dispatch(false)
                })
            .do(onCompleted: { error in
                // do nothing
                })
            .subscribe(onNext: { [unowned self] response in
                let searchUser = SearchUser.make(from: query, gitHubResponse: response)
                if page == 0 {
                    self.dispatcher.searchUser.dispatch(searchUser)
                } else {
                    let storedViewModel = self.store.rx.searchUser.value
                    self.dispatcher.searchUser.dispatch(storedViewModel.update(with: searchUser))
                }
                self.dispatcher.loading.dispatch(false)
                })
            .addDisposableTo(disposeBag)
    }
    
    func contentOffset(_ value: CGPoint) {
        dispatcher.contentOffset.dispatch(value)
    }
    
    func scrollViewDidEndDragging(decelerate: Bool) {
        dispatcher.scrollViewDidEndDragging.dispatch(decelerate)
    }
}


extension SearchUserAction {
    static func loading(_ value: Bool) {
        shared.loading(value)
    }
    
    static func searchUser(query: String, page: Int) {
        shared.searchUser(query: query, page: page)
    }
    
    static func contentOffset(_ value: CGPoint) {
        shared.contentOffset(value)
    }
    
    static func scrollViewDidEndDragging(decelerate: Bool) {
        shared.scrollViewDidEndDragging(decelerate: decelerate)
    }
}
