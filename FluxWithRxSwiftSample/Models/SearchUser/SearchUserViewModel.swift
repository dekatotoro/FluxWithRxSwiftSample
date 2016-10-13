//
//  SearchUser.swift
//  FluxWithRxSwiftSample
//
//  Created by Yuji Hato on 2016/10/13.
//  Copyright © 2016年 dekatotoro. All rights reserved.
//

import Foundation

struct SearchUser {
    
    var userName: String = ""
    var users: [GitHubUser] = []
    var totalCount: Int?
    var linkHeader: GitHubLinkHeader?
 
    init() {}
 
    static func make(userName: String, gitHubResponse: GitHubResponse<[GitHubUser]>) -> SearchUser {
        var viewModel = SearchUser()
        viewModel.userName = userName
        viewModel.users = gitHubResponse.resource
        viewModel.totalCount = gitHubResponse.totalCount
        viewModel.linkHeader = gitHubResponse.linkHeader
        return viewModel
    }
    
    func update(viewModel: SearchUser) -> SearchUser {
        var new = SearchUser()
        new.userName = viewModel.userName
        new.users = (users + viewModel.users)
        new.totalCount = viewModel.totalCount
        new.linkHeader = viewModel.linkHeader
        return new
    }
    
    var totalCountText: String {
        let count = totalCount ?? users.count
        return "\(users.count)/\(count)件"
    }
}
