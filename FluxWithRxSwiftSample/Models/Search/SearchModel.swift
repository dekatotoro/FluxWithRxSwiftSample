//
//  SearchModel.swift
//  FluxWithRxSwiftSample
//
//  Created by Yuji Hato on 2016/10/16.
//  Copyright © 2016年 dekatotoro. All rights reserved.
//

struct SearchModel<T> {
    
    var searchkey: String = ""
    var elements: [T] = []
    var totalCount: Int?
    var linkHeader: GitHubLinkHeader?
    
    init() {}
    
    static func make(from searchkey: String, gitHubResponse: GitHubResponse<[T]>) -> SearchModel {
        var searchModel = SearchModel<T>()
        searchModel.searchkey = searchkey
        searchModel.elements = gitHubResponse.resource
        searchModel.totalCount = gitHubResponse.totalCount
        searchModel.linkHeader = gitHubResponse.linkHeader
        return searchModel
    }
    
    func concat(searchModel: SearchModel) -> SearchModel<T> {
        var new = SearchModel<T>()
        new.searchkey = searchModel.searchkey
        new.elements = (elements + searchModel.elements)
        new.totalCount = searchModel.totalCount
        new.linkHeader = searchModel.linkHeader
        return new
    }
    
    var nextPage: Int? {
        return linkHeader?.next?.page
    }
    
    var totalCountText: String {
        let count = totalCount ?? elements.count
        return "\(elements.count)/\(count)件"
    }
}
