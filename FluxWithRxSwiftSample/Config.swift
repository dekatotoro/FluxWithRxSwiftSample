//
//  Config.swift
//  FluxWithRxSwiftSample
//
//  Created by Yuji Hato on 2016/10/13.
//  Copyright © 2016年 dekatotoro. All rights reserved.
//



struct Config {
    struct GitHub {
        let apiToken: String
        let apiBaseURL: String
        
        init() {
            apiToken = "your api token"
            apiBaseURL = "https://api.github.com"
        }
    }
    
    static let gitHub = GitHub()
    
}
