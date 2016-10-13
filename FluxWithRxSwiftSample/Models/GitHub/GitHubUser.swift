//
//  GitHubUser.swift
//  FluxWithRxSwiftSample
//
//  Created by Yuji Hato on 2016/10/13.
//  Copyright © 2016年 dekatotoro. All rights reserved.
//
import Himotoki

struct GitHubUser: Decodable {
    let name: String
    let url: String
    let imageUrl: String
    
    static func decode(_ e: Extractor) throws -> GitHubUser {
        return try GitHubUser(
            name: e <| "login",
            url: e <| "url",
            imageUrl: e <| "avatar_url"
        )
    }
}
