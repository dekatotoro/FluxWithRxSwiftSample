//
//  ErrorNoticeStore.swift
//  FluxWithRxSwiftSample
//
//  Created by Yuji Hato on 2016/10/13.
//  Copyright © 2016年 dekatotoro. All rights reserved.
//
import UIKit
import RxSwift

func == (lhs: ErrorNoticeType, rhs: ErrorNoticeType) -> Bool {
    switch (lhs, rhs) {
    case (.apiError(let lhs), .apiError(let rhs)):
        return lhs.localizedDescription == rhs.localizedDescription
    }
}

enum ErrorNoticeType: CustomStringConvertible, Equatable {
    case apiError(Error)
    
    var description: String {
        switch self {
        case .apiError(let error):
            return "通信に失敗しました\n\(error.localizedDescription)"
        }
    }
}

class ErrorNoticeStore: Store, ReactiveCompatible {
    
    static let shared = ErrorNoticeStore()
    
    fileprivate let noticeTypes = Variable<[ErrorNoticeType]>([])
    fileprivate let show = PublishSubject<ErrorNoticeType>()
    fileprivate let hide = PublishSubject<Void>()
    
    init(dispatcher: ErrorNoticeDispatcher = ErrorNoticeDispatcher.shared) {
        super.init()
        
     dispatcher.addError
            .filter { [unowned self] type -> Bool in
                // Not show same type error
                let sameErrors = self.noticeTypes.value.filter { $0 == type }
                return sameErrors.isEmpty
            }
            .subscribe(onNext: { [unowned self] type in
                self.noticeTypes.value.append(type)
                
                if self.noticeTypes.value.count <= 1 {
                    // Show first
                    self.show.onNext(type)
                }
            })
            .addDisposableTo(disposeBag)

        dispatcher.removeError
            .subscribe(onNext: { [unowned self] noticeType in
                if self.noticeTypes.value.first == noticeType {
                    // Remove showing error
                    self.noticeTypes.value.removeFirst()
                    self.hide.onNext()
                } else {
                    // Remove pending error
                    if let index = self.noticeTypes.value.index(of: noticeType) {
                        self.noticeTypes.value.remove(at: index)
                    }
                }
            })
            .addDisposableTo(disposeBag)

        dispatcher.removeAll
            .filter { [unowned self] in self.noticeTypes.value.count >= 1 }
            .subscribe(onNext: { [unowned self] in
                // Remove All
                self.noticeTypes.value = []
            })
            .addDisposableTo(disposeBag)
        
        dispatcher.next
            .map { [unowned self] in self.noticeTypes.value.first }
            .filterNil()
            .subscribe(onNext: { [unowned self] next in
                self.show.onNext(next)
            })
            .addDisposableTo(disposeBag)

        dispatcher.hide
            .bindTo(hide)
            .addDisposableTo(disposeBag)
        
    }
}

extension Reactive where Base: ErrorNoticeStore {
    
    var noticeTypes: Variable<[ErrorNoticeType]> {
        return base.noticeTypes
    }
    
    var show: PublishSubject<ErrorNoticeType> {
        return base.show
    }
    
    var error: PublishSubject<Void> {
        return base.hide
    }
}

