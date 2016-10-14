//
//  SearchInputView.swift
//  FluxWithRxSwiftSample
//
//  Created by Yuji Hato on 2016/10/13.
//  Copyright © 2016年 dekatotoro. All rights reserved.
//


import UIKit
import RxSwift

class SearchInputView: UIView, Nibable {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var numberLable: UILabel!
    
    private let store = SearchUserStore.shared
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureUI()
        observeStore()
        observeUI()
    }
    
    private func configureUI() {
        searchBar.barTintColor = .lightGray
        searchBar.tintColor = .gray
        searchBar.layer.borderColor = UIColor.lightGray.cgColor
        searchBar.layer.borderWidth = 1
        numberLable.textColor = .gray
    }
    
    private func observeStore() {
        
        store.rx.searchUser.asObservable()
            .map { $0.totalCountText }
            .subscribe(onNext: { [unowned self] totalCountText in
                self.numberLable.text = totalCountText
                })
            .addDisposableTo(rx_disposeBag)
        
        // Dismiss keyboard on scroll
        store.rx.scrollViewDidEndDragging
            .subscribe(onNext: { _ in
                if self.searchBar.isFirstResponder {
                    _ = self.searchBar.resignFirstResponder()
                }
            })
            .addDisposableTo(rx_disposeBag)
    }
    
    private func observeUI() {
        searchBar.rx.text.asDriver()
            .throttle(0.3)
            .distinctUntilChanged()
            .drive(onNext: { query in
                SearchUserAction.searchUser(query: query, page: 0)
            })
            .addDisposableTo(rx_disposeBag)
    }
}
