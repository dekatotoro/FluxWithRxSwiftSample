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
                    switch error {
                    case .connectionError(let error):
                        if (error as NSError).code == URLError.cancelled.rawValue {
                            // onCompleted when cancelled
                            observer.onCompleted()
                            break
                        }
                        observer.onError(error)
                    default:
                        observer.onError(error)
                    }
                }
            })
            return Disposables.create()
        }
        return observable.take(1)
        
    }
    
    static func cancelSearchUser() {
        Session.cancelRequests(with: SearchUserRequest.self)
    }
}

