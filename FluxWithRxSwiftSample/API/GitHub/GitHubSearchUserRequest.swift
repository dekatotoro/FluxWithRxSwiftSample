//
//  GitHubSearchUserRequest.swift
//  FluxWithRxSwiftSample
//
//  Created by Yuji Hato on 2016/10/13.
//  Copyright © 2016年 dekatotoro. All rights reserved.
//

import APIKit
import Himotoki

// https://developer.github.com/v3/users/followers/
struct SearchUserRequest: GitHubRequest {
    typealias Response = GitHubResponse<[GitHubUser]>
    
    let customParams: [String : Any]?
    
    init(customParams: [String : Any]?) {
        self.customParams = customParams
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        return "/search/users"
    }
    
    var queryParameters: [String : Any]? {
        return customParams
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        if let link = urlResponse.allHeaderFields.filter({ $0.key.description == "Link"}).first,
            let linkValue = link.value as? String {
            print(linkValue)
            
        }
        
        let totalCount: Int = try! decodeValue(object, rootKeyPath: "total_count")
        let incompleteResults: Bool = try! decodeValue(object, rootKeyPath: "incomplete_results")
        let users: [GitHubUser] = try! decodeArray(object, rootKeyPath: "items")
        let linkHeader = headerParameters(urlResponse)
        let response = GitHubResponse(resource: users,
                                      totalCount: totalCount,
                                      incomplete_results: incompleteResults,
                                      linkHeader: linkHeader)
        return response
    }
    
    func headerParameters(_ urlResponse: HTTPURLResponse) -> GitHubLinkHeader? {
        let linkHeader: GitHubLinkHeader?
        if let linkHeaderString = urlResponse.allHeaderFields["Link"] as? String {
            linkHeader = GitHubLinkHeader(string: linkHeaderString)
        } else {
            linkHeader = nil
        }
        return linkHeader
    }
}

