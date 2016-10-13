//
//  CellNibable.swift
//  FluxWithRxSwiftSample
//
//  Created by Yuji Hato on 2016/10/13.
//  Copyright © 2016年 dekatotoro. All rights reserved.
//

import UIKit

protocol CellNibable: Nibable {
    static var identifier: String { get }
}

extension CellNibable {
    static var identifier: String {
        return className
    }
}

extension UITableViewCell: CellNibable {}
extension UICollectionReusableView: CellNibable {}
