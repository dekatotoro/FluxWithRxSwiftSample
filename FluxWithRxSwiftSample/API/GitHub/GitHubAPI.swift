//
//  API.swift
//  FluxWithRxSwitSample
//
//  Created by Yuji Hato on 2016/10/13.
//  Copyright © 2016年 DEKATOTORO. All rights reserved.
//

import APIKit
import Himotoki
import RxSwift

protocol GitHubRequest: Request {}

extension GitHubRequest {
    var baseURL: URL {
        return URL(string: Config.gitHub.apiBaseURL)!
    }
    
    var headerFields: [String: String] {
        return ["Authorization": "token \(Config.gitHub.apiToken)",
                "Content-Type" : "application/json; charset=utf-8",
                "Accept" : "application/vnd.github.v3+json"]
    }
}

extension GitHubRequest where Response: Decodable {
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        return try Response.decodeValue(object)
    }
}

struct GitHubResponse<T> {
    var resource: T
    var totalCount: Int?
    var incomplete_results: Bool
    var linkHeader: GitHubLinkHeader?
}


struct GitHubAPI {
    static func searchUser(with params: [String : Any]?) -> Observable<GitHubResponse<[GitHubUser]>>  {
        let request = SearchUserRequest(customParams: params)
        
        let observable = Observable<GitHubResponse<[GitHubUser]>>.create { observer -> Disposable in
            Session.send(request, callbackQueue: .main, handler: { result in
                switch result {
                case .success(let users):
                    observer.on(.next(users))
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            })
            return Disposables.create()
        }
        return observable.take(1)
        
    }
}

