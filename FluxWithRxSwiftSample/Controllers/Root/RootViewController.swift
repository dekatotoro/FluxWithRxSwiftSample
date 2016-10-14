//
//  RootViewController.swift
//  FluxWithRxSwiftSample
//
//  Created by Yuji Hato on 2016/10/13.
//  Copyright © 2016年 dekatotoro. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import NavigationNotice

class RootViewController: UIViewController, Storyboardable {
    
    var currentViewController: UIViewController? {
        willSet {
            guard let currentViewController = newValue
                , childViewControllers.contains(currentViewController) == false else { return }
            addChild(currentViewController)
        }
        didSet {
            guard let currentViewController = oldValue else { return }
            currentViewController.removeFromParent()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.currentViewController = SearchUserViewController.makeFromStoryboard()
        
        observeStore()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
   
    private func observeStore() {
        ErrorNoticeStore.shared.rx.show
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] noticeType in
                let errorNoticeView = ErrorNoticeView.make(with: noticeType)
                NavigationNotice
                    .addContent(errorNoticeView)
                    .showOn(self.view)
                    .completion {
                        ErrorNoticeAction.remove(noticeType)
                        ErrorNoticeAction.next()
                }
                })
            .addDisposableTo(rx_disposeBag)
    }
   
}

