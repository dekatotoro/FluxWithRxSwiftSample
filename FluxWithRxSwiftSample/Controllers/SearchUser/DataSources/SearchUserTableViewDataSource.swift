//
//  SearchUserTableViewDataSource.swift
//  FluxWithRxSwiftSample
//
//  Created by Yuji Hato on 2016/10/13.
//  Copyright © 2016年 dekatotoro. All rights reserved.
//


import UIKit
import RxSwift

class SearchUserTableViewDataSource: NSObject {
    
    weak var tableView: UITableView?
    let users = Variable<[GitHubUser]>([])
    
    fileprivate let store: SearchUserStore = .shared
    
    func register(tableView: UITableView) {
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.registerCell(cell: SearchUserCell.self)
        self.tableView = tableView
        
        observeStore()
    }
    
    private func observeStore() {
        store.rx.searchUser.asObservable()
            .map { $0.elements }
            .subscribe(onNext: { [unowned self] elements in
                self.users.value = elements
                self.tableView?.reloadData()
                })
            .addDisposableTo(rx_disposeBag)
    }
}

extension SearchUserTableViewDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(type: SearchUserCell.self)
        cell.configure(user: users.value[indexPath.row])
        return cell
    }
}

extension SearchUserTableViewDataSource: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.5
    }
}

extension SearchUserTableViewDataSource: UIScrollViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        SearchUserAction.scrollViewDidEndDragging(decelerate: decelerate)
    }
}
