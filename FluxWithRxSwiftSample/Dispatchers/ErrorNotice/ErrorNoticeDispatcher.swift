//
//  ErrorNoticeDispatcher.swift
//  FluxWithRxSwiftSample
//
//  Created by Yuji Hato on 2016/10/13.
//  Copyright © 2016年 dekatotoro. All rights reserved.
//


struct ErrorNoticeDispatcher {
    static let shared = ErrorNoticeDispatcher()
    
    let addError = DispatchSubject<(ErrorNoticeType)>()
    let removeError = DispatchSubject<ErrorNoticeType>()
    let removeAll = DispatchSubject<Void>()
    let next = DispatchSubject<Void>()
    let hide = DispatchSubject<Void>()
}
