//
//  ViewController.swift
//  FluxWithRxSwiftSample
//
//  Created by Yuji Hato on 2016/10/13.
//  Copyright © 2016年 dekatotoro. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Cartography

class SearchUserViewController: UIViewController, Storyboardable {
    
    @IBOutlet weak var searchInputContainer: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    let loadingView = LoadingView()
    
    private let store = SearchUserStore.shared
    private let tableViewDataSource = SearchUserTableViewDataSource()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        observeStore()
        observeUI()
    }
    
    private func configureUI() {
        view.backgroundColor = UIColor.lightGray
        loadingView.setType(LoadingView.LoadingType.point)
        view.addConstrainEdges(loadingView)
        let searchInputView = SearchUserInputView.makeFromNib()
        searchInputContainer.addConstrainEdges(searchInputView)
        
        tableViewDataSource.register(tableView: tableView)
    }
    
    private func observeStore() {
        
        store.rx.loading.asObservable()
            .distinctUntilChanged()
            .subscribe(onNext: { [unowned self] loading in
                self.loadingView.hidden(!loading)
                })
            .addDisposableTo(rx_disposeBag)
        
        store.rx.error
            .subscribe(onNext: { error in
                ErrorNoticeAction.show(.apiError(error))
                })
            .addDisposableTo(rx_disposeBag)
    }
    
    private func observeUI() {
        
        let rx_contentOffsset = tableView.rx.contentOffset.shareReplay(1)
        
        rx_contentOffsset
            .flatMap { contentOffset in
                self.tableView.isNearBottomEdge(edgeOffset: 20.0)
                    ? Observable.just(contentOffset)
                    : Observable.empty()
            }
            .filter { [unowned self] _ in
                self.store.rx.searchUser.value.linkHeader?.hasNextPage == true &&
                self.store.rx.loading.value == false
            }
            .subscribe(onNext:{ [unowned self] _ in
            guard let nextPage = self.store.rx.searchUser.value.nextPage else { return }
            SearchUserAction.searchUser(query: self.store.rx.searchUser.value.searchkey, page: nextPage)
            })
            .addDisposableTo(rx_disposeBag)
        
        rx_contentOffsset
            .subscribe(onNext: { contentOffset in
                SearchUserAction.contentOffset(contentOffset)
            })
            .addDisposableTo(rx_disposeBag)
    }
}



