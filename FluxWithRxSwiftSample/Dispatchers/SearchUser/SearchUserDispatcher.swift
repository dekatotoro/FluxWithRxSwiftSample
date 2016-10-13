//
//  SearchUserDispatcher.swift
//  FluxWithRxSwiftSample
//
//  Created by Yuji Hato on 2016/10/13.
//  Copyright © 2016年 dekatotoro. All rights reserved.
//


class SearchUserDispatcher {
    static let shared = SearchUserDispatcher()
    
    let loading = DispatchSubject<Bool>()
    let error = DispatchSubject<Error>()
    let viewModel = DispatchSubject<SearchUser>()    
}
