//
//  Storyboardable.swift
//  FluxWithRxSwiftSample
//
//  Created by Yuji Hato on 2016/10/13.
//  Copyright © 2016年 dekatotoro. All rights reserved.
//

import UIKit

protocol Storyboardable: NSObjectProtocol {
    associatedtype Instance
    static func makeFromStoryboard() -> Instance
    static var storyboard: UIStoryboard { get }
    static var storyboardName: String { get }
    static var identifier: String { get }
}

extension Storyboardable {
    static var storyboardName: String {
        return className
    }
    
    static var identifier: String {
        return className
    }
    
    static var storyboard: UIStoryboard {
        return UIStoryboard(name: storyboardName, bundle: nil)
    }
    
    static func makeFromStoryboard() -> Self {
        return storyboard.instantiateViewController(withIdentifier: identifier) as! Self
    }
}
