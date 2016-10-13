//
//  LoadingView.swift
//  FluxWithRxSwiftSample
//
//  Created by Yuji Hato on 2016/10/13.
//  Copyright © 2016年 dekatotoro. All rights reserved.
//

import UIKit
import Cartography
import SpringIndicator

private let LaodingIndicatorSize: CGFloat = 32

class LoadingView: UIView {
    
    enum LoadingType {
        case fullScreen, fullGuard, point
    }
    
    fileprivate(set) var loadingType: LoadingType = .point
    
    let indicator = SpringIndicator(frame: CGRect(x: 0, y: 0, width: LaodingIndicatorSize, height: LaodingIndicatorSize))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    func initialize() {
        indicator.lineColor = UIColor.gray
        indicator.lineWidth = 3
        indicator.lineCap = true
        indicator.rotateDuration = 1.1
        indicator.strokeDuration = 0.7
        addSubview(indicator)
        isHidden = true
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return loadingType == .fullGuard
    }
    
    @discardableResult
    func setType(_ loadingType: LoadingType) -> LoadingView {
        self.loadingType = loadingType
        backgroundColor = (loadingType == .fullGuard) ? UIColor.black.withAlphaComponent(0.5) : .clear
        
        let isFullScreen = (loadingType == .fullScreen || loadingType == .fullGuard)
        indicator.lineColor = isFullScreen ? UIColor.white : UIColor.gray
        
        constrain(indicator) { (view) in
            view.width == LaodingIndicatorSize
            view.height == LaodingIndicatorSize
        }
        
        constrain(indicator, self) { (view, superview) in
            if isFullScreen {
                let margin: CGFloat = 24
                view.bottom == superview.bottom - margin
                view.right == superview.right - margin
            } else {
                view.center == superview.center
            }
        }
        
        return self
    }
    
    func hidden(_ hidden: Bool) {
        self.isHidden = hidden
        
        if hidden {
            indicator.stopAnimation(false)
        } else {
            indicator.startAnimation()
        }
    }
}
