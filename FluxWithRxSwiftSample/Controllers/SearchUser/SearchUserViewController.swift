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
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var numberLable: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let loadingView = LoadingView()
    
    private let store = SearchUserStore.shared
    private let tableViewDataSource = SearchUserTableViewDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingView.setType(LoadingView.LoadingType.point)
        view.addConstrainEdges(loadingView)
        
        tableViewDataSource.register(tableView: tableView)
        
        observeStore()
        observeUI()
    }
    
    private func observeStore() {
        
        store.rx.loading.asObservable()
            .distinctUntilChanged()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] loading in
                self.loadingView.hidden(!loading)
                })
            .addDisposableTo(rx_disposeBag)
        
        store.rx.error
            .subscribe(onNext: { error in
                ErrorNoticeAction.show(.apiError(error))
                })
            .addDisposableTo(rx_disposeBag)
        
        store.rx.searchUser.asObservable()
            .map { $0.totalCountText }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] totalCountText in
                self.numberLable.text = totalCountText
                })
            .addDisposableTo(rx_disposeBag)
    }
    
    private func observeUI() {
        searchBar.rx.text.asObservable()
            .throttle(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { query in
                SearchUserAction.searchUser(query: query, page: 0)
            })
            .addDisposableTo(rx_disposeBag)
        
        tableView.rx.contentOffset
            .flatMap { _ in
                self.tableView.isNearBottomEdge(edgeOffset: 20.0)
                    ? Observable.just(())
                    : Observable.empty()
            }
            .filter { [unowned self] in
                self.store.rx.searchUser.value.linkHeader?.hasNextPage == true
            }
            .subscribe(onNext:{ [unowned self] in
                guard let nextPage = self.store.rx.searchUser.value.nextPage else { return }
                SearchUserAction.searchUser(query: self.store.rx.searchUser.value.userName, page: nextPage)
                })
            .addDisposableTo(rx_disposeBag)
        
        
        // Dismiss keyboard on scroll
        tableView.rx.contentOffset
            .subscribe { _ in
                if self.searchBar.isFirstResponder {
                    _ = self.searchBar.resignFirstResponder()
                }
            }
            .addDisposableTo(rx_disposeBag)
    }
}



