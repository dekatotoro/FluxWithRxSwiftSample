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
    
    func loading(value: Bool) {
        self.dispatcher.loading.dispatch(value)
    }
    
    func searchUser(query: String, page: Int) {
        guard store.rx.loading.value == false else { return }
        dispatcher.loading.dispatch(true)

        if query.isEmpty {
            dispatcher.viewModel.dispatch(SearchUser())
            dispatcher.loading.dispatch(false)
            return
        }
        
        let params = ["q" : query,
                      "page" : page,
                      "per_page" : 30] as [String : Any]
        GitHubAPI.searchUser(customParams: params)
            .do(onError: { [unowned self] error in
                self.dispatcher.error.dispatch(error)
                self.dispatcher.loading.dispatch(false)
                })
            .do(onCompleted: {  [unowned self] error in
                self.dispatcher.loading.dispatch(false)
                })
            .subscribe(onNext: { [unowned self] response in
                let viewModel = SearchUser.make(userName: query, gitHubResponse: response)
                if page == 0 {
                    self.dispatcher.viewModel.dispatch(viewModel)
                } else {
                    let storedViewModel = self.store.rx.viewModel.value
                    self.dispatcher.viewModel.dispatch(storedViewModel.update(viewModel: viewModel))
                }
                })
            .addDisposableTo(disposeBag)
    }
}


extension SearchUserAction {
    static func loading(value: Bool) {
        shared.loading(value: value)
    }
    
    static func searchUser(query: String, page: Int) {
        shared.searchUser(query: query, page: page)
    }
}
