//
//  ErrorNoticeAction.swift
//  FluxWithRxSwiftSample
//
//  Created by Yuji Hato on 2016/10/13.
//  Copyright © 2016年 dekatotoro. All rights reserved.
//

import Foundation

struct ErrorNoticeAction {
    static let shared = ErrorNoticeAction()
    
    fileprivate let errorNoticeDispatcher: ErrorNoticeDispatcher
    
    init(errorNoticeDispatcher: ErrorNoticeDispatcher = .shared) {
        self.errorNoticeDispatcher = errorNoticeDispatcher
    }
    
    func show(_ type: ErrorNoticeType) {
        errorNoticeDispatcher.addError.dispatch(type)
    }
    
    func hide() {
        errorNoticeDispatcher.hide.dispatch()
    }
    
    func remove(_ type: ErrorNoticeType) {
        errorNoticeDispatcher.removeError.dispatch(type)
    }
    
    func removeAll() {
        errorNoticeDispatcher.removeAll.dispatch()
    }
    
    func next() {
        errorNoticeDispatcher.next.dispatch()
    }
    
}

extension ErrorNoticeAction {
    static func show(_ type: ErrorNoticeType) { shared.show(type) }
    static func remove(_ type: ErrorNoticeType) { shared.remove(type) }
    static func removeAll() { shared.removeAll() }
    static func next() { shared.next() }
    static func hide() { shared.hide() }
}
