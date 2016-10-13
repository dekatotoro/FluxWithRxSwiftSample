//
//  ReusableViewNibable.swift
//  FluxWithRxSwiftSample
//
//  Created by Yuji Hato on 2016/10/13.
//  Copyright © 2016年 dekatotoro. All rights reserved.
//

import UIKit

protocol ReusableViewNibable: Nibable {
    static var identifier: String { get }
}

extension ReusableViewNibable {
    static var identifier: String {
        return className
    }
}

extension UITableViewHeaderFooterView: ReusableViewNibable {}
