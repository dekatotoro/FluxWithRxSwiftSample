//
//  UITableViewCellExtension.swift
//  FluxWithRxSwiftSample
//
//  Created by Yuji Hato on 2016/10/13.
//  Copyright © 2016年 dekatotoro. All rights reserved.
//

import UIKit

extension UITableView {
    func reloadToStartPosition(includeInset: Bool = false) {
        reloadData()
        contentOffset = includeInset ? CGPoint(x: 0, y: contentInset.top) : .zero
    }
    
    //register.
    func registerCell<T: CellNibable>(cell: T.Type) {
        register(cell.nib, forCellReuseIdentifier: cell.identifier)
    }
    
    func registerHeaderFooterView<T: ReusableViewNibable>(headerFooterView: T.Type) {
        register(headerFooterView.nib, forHeaderFooterViewReuseIdentifier: headerFooterView.identifier)
    }
    
    //dequeue.
    func dequeueReusableCellWithIdentifier<T>(identifier: String) -> T {
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
    
    func dequeueReusableCellWithIdentifier<T>(identifier: String, forIndexPath indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! T
    }
    
    func dequeueReusableCell<T: CellNibable>(type: T.Type) -> T {
        return dequeueReusableCell(withIdentifier: type.identifier) as! T
    }
    
    func dequeueReusableCell<T: CellNibable>(type: T.Type, forIndexPath indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: type.identifier, for: indexPath) as! T
    }
    
    func dequeueReusableHeaderFooterViewWithIdentifier<T>(identifier: String) -> T {
        return dequeueReusableHeaderFooterView(withIdentifier: identifier) as! T
    }
    
    func dequeueReusableHeaderFooterView<T: ReusableViewNibable>(type: T.Type) -> T {
        return dequeueReusableHeaderFooterViewWithIdentifier(identifier: type.identifier)
    }
}

extension UITableView {
    func cellsForRowAtIndexPathRow<T>(row: Int) -> [T] {
        guard let indexPaths = indexPathsForVisibleRows else {
            return []
        }
        
        let cells = indexPaths.filter { $0.row == row }.map { cellForRow(at: $0) }
        return cells.flatMap { $0 as? T }
    }
}
