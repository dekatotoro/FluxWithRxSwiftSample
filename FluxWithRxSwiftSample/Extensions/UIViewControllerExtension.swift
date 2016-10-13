//
//  UIViewControllerExtension.swift
//  FluxWithRxSwiftSample
//
//  Created by Yuji Hato on 2016/10/13.
//  Copyright © 2016年 dekatotoro. All rights reserved.
//

import UIKit

extension UIViewController {
    func addChild(_ childController: UIViewController) {
        addChildViewController(childController)
        view.addSubview(childController.view)
        childController.didMove(toParentViewController: self)
    }
    
    func insertChild(_ childController: UIViewController, belowViewController: UIViewController) {
        addChildViewController(childController)
        view.insertSubview(childController.view, belowSubview: belowViewController.view)
        childController.didMove(toParentViewController: self)
    }
    
    func removeFromParent() {
        willMove(toParentViewController: nil)
        view.removeFromSuperview()
        removeFromParentViewController()
    }
    
}

