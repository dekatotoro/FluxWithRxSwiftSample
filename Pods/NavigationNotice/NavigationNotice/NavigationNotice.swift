//
//  NavigationNotice.swift
//  NavigationNotice
//
//  Created by Kyohei Ito on 2015/02/06.
//  Copyright (c) 2015年 kyohei_ito. All rights reserved.
//

import UIKit

open class NavigationNotice {
    class ViewController: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate {
        class HitView: UIView {
            override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
                if let superView = super.hitTest(point, with: event) {
                    if superView != self {
                        return superView
                    }
                }
                return nil
            }
        }
        
        class HitScrollView: UIScrollView {
            override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
                if let superView = super.hitTest(point, with: event) {
                    if superView != self {
                        return superView
                    }
                }
                return nil
            }
        }
        
        fileprivate lazy var panGesture: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ViewController.panGestureAction(_:)))
        fileprivate var scrollPanGesture: UIPanGestureRecognizer? {
            return noticeView.gestureRecognizers?.filter({ $0 as? UIPanGestureRecognizer != nil }).first as? UIPanGestureRecognizer
        }
        fileprivate lazy var noticeView: HitScrollView = HitScrollView(frame: self.view.bounds)
        fileprivate weak var targetView: UIView? {
            didSet { targerWindow = targetView?.window }
        }
        fileprivate weak var targerWindow: UIWindow?
        fileprivate var targetController: UIViewController? {
            return targerWindow?.rootViewController
        }
        fileprivate var childController: UIViewController? {
            return targetController?.presentedViewController ?? targetController
        }
        fileprivate var contentView: UIView?
        fileprivate var autoHidden: Bool = false
        fileprivate var hiddenTimeInterval: TimeInterval = 0
        fileprivate var contentHeight: CGFloat {
            return noticeView.bounds.height
        }
        fileprivate var contentOffsetY: CGFloat {
            set { noticeView.contentOffset.y = newValue }
            get { return noticeView.contentOffset.y }
        }
        fileprivate var hiddenTimer: Timer? {
            didSet {
                oldValue?.invalidate()
            }
        }
        
        var showAnimations: ((@escaping () -> Void, @escaping (Bool) -> Void) -> Void)?
        var hideAnimations: ((@escaping () -> Void, @escaping (Bool) -> Void) -> Void)?
        var hideCompletionHandler: (() -> Void)?
        
        override var shouldAutorotate : Bool {
            return childController?.shouldAutorotate
                ?? super.shouldAutorotate
        }
        
        override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
            return childController?.supportedInterfaceOrientations
                ?? super.supportedInterfaceOrientations
        }
        
        override var preferredInterfaceOrientationForPresentation : UIInterfaceOrientation {
            return childController?.preferredInterfaceOrientationForPresentation
                ?? super.preferredInterfaceOrientationForPresentation
        }
        
        override var childViewControllerForStatusBarStyle : UIViewController? {
            return childController
        }
        
        override var childViewControllerForStatusBarHidden : UIViewController? {
            return childController
        }
        
        override func loadView() {
            super.loadView()
            view = HitView(frame: view.bounds)
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            panGesture.delegate = self
            
            noticeView.clipsToBounds = false
            noticeView.showsVerticalScrollIndicator = false
            noticeView.isPagingEnabled = true
            noticeView.bounces = false
            noticeView.delegate = self
            noticeView.autoresizingMask = .flexibleWidth
            view.addSubview(noticeView)
        }
        
        func setInterval(_ interval: TimeInterval) {
            hiddenTimeInterval = interval
            
            if interval >= 0 {
                autoHidden = true
                
                if panGesture.view != nil {
                    timer(interval)
                }
            } else {
                autoHidden = false
            }
        }
        
        func setContent(_ view: UIView) {
            contentView = view
        }
        
        func removeContent() {
            contentView?.removeFromSuperview()
            contentView = nil
        }
        
        func timer(_ interval: TimeInterval) {
            let handler: (CFRunLoopTimer?) -> Void = { [weak self] timer in
                self?.hiddenTimer = nil
                self?.hiddenTimeInterval = 0
                
                if self?.autoHidden == true {
                    if self?.panGesture.state != .changed && self?.scrollPanGesture?.state != .some(.changed) {
                        self?.hide(true)
                    }
                }
            }
            
            if interval > 0 {
                let fireDate = interval + CFAbsoluteTimeGetCurrent()
                let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, 0, 0, 0, handler)
                CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, CFRunLoopMode.commonModes)
                hiddenTimer = timer
            } else {
                handler(nil)
            }
        }
        
        func showOn(_ view: UIView) {
            targetView = view
            
            if let view = contentView {
                noticeView.frame.size.height = view.frame.height
                view.frame.size.width = noticeView.bounds.width
                view.frame.origin.y = -contentHeight
                view.autoresizingMask = .flexibleWidth
                noticeView.addSubview(view)
                view.setNeedsDisplay()
            }
            
            noticeView.contentSize = noticeView.bounds.size
            noticeView.contentInset.top = contentHeight
            
            show() {
                self.targetView?.addGestureRecognizer(self.panGesture)
                
                if self.autoHidden == true {
                    self.timer(self.hiddenTimeInterval)
                }
            }
        }
        
        func show(_ completion: @escaping () -> Void) {
            showContent({
                self.contentOffsetY = -self.contentHeight
                self.setNeedsStatusBarAppearanceUpdate()
                }) { _ in
                    completion()
            }
        }
        
        func hide(_ animated: Bool) {
            targetView?.removeGestureRecognizer(panGesture)
            hiddenTimeInterval = 0
            autoHidden = false
            
            if animated == true {
                hideContent({
                    self.contentOffsetY = 0
                    self.setNeedsStatusBarAppearanceUpdate()
                    }) { _ in
                        self.removeContent()
                        self.hideCompletionHandler?()
                }
            } else {
                self.setNeedsStatusBarAppearanceUpdate()
                removeContent()
                hideCompletionHandler?()
            }
        }
        
        func hideIfNeeded(_ animated: Bool) {
            if autoHidden == true && hiddenTimeInterval <= 0 {
                hide(animated)
            }
        }
        
        func panGestureAction(_ gesture: UIPanGestureRecognizer) {
            if contentOffsetY >= 0 {
                hide(false)
                return
            }
            
            let locationOffsetY = gesture.location(in: view).y
            
            if gesture.state == .changed {
                if contentHeight > locationOffsetY {
                    contentOffsetY = -locationOffsetY
                } else {
                    contentOffsetY = -contentHeight
                }
            } else if gesture.state == .cancelled || gesture.state == .ended {
                if contentHeight < locationOffsetY {
                    contentOffsetY = -contentHeight
                    
                    hideIfNeeded(true)
                    return
                }
                
                if gesture.velocity(in: view).y > 0 {
                    show() {
                        self.hideIfNeeded(true)
                    }
                } else {
                    hide(true)
                }
            }
        }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            if contentOffsetY >= 0 {
                hide(false)
            } else {
                hideIfNeeded(true)
            }
        }
        
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return gestureRecognizer == panGesture || otherGestureRecognizer == panGesture
        }
        
        func showContent(_ animations: @escaping () -> Void, completion: @escaping (Bool) -> Void) {
            if let show = showAnimations {
                show(animations, completion)
            } else {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .beginFromCurrentState, animations: animations, completion: completion)
            }
        }
        
        func hideContent(_ animations: @escaping () -> Void, completion: @escaping (Bool) -> Void) {
            if let hide = hideAnimations {
                hide(animations, completion)
            } else {
                UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .beginFromCurrentState, animations: animations, completion: completion)
            }
        }
    }

    fileprivate class NoticeManager {
        class HitWindow: UIWindow {
            override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
                if let superWindow = super.hitTest(point, with: event) {
                    if superWindow != self {
                        return superWindow
                    }
                }
                return nil
            }
        }
        
        fileprivate weak var mainWindow: UIWindow?
        fileprivate var noticeWindow: HitWindow?
        fileprivate var contents: [NavigationNotice] = []
        fileprivate var showingNotice: NavigationNotice?
        fileprivate var onStatusBar: Bool = true
        fileprivate var showAnimations: ((@escaping () -> Void, @escaping (Bool) -> Void) -> Void)?
        fileprivate var hideAnimations: ((@escaping () -> Void, @escaping (Bool) -> Void) -> Void)?
        
        fileprivate func startNotice(_ notice: NavigationNotice) {
            showingNotice = notice
            
            noticeWindow?.rootViewController = notice.noticeViewController
            noticeWindow?.windowLevel = UIWindowLevelStatusBar + (notice.onStatusBar ? 1 : -1)
            
            if let view = notice.noticeViewController.targetView {
                mainWindow = view.window
                
                notice.noticeViewController.showOn(view)
            }
        }
        
        fileprivate func endNotice() {
            showingNotice?.noticeViewController.setNeedsStatusBarAppearanceUpdate()
            showingNotice = nil
            
            mainWindow?.makeKeyAndVisible()
            noticeWindow = nil
        }
        
        func next() {
            if let notice = pop() {
                startNotice(notice)
            } else {
                endNotice()
            }
        }
        
        func add(_ notice: NavigationNotice) {
            contents.append(notice)
            
            DispatchQueue.main.async {
                if self.showingNotice == nil {
                    self.noticeWindow = HitWindow(frame: UIScreen.main.bounds)
                    self.noticeWindow?.makeKeyAndVisible()
                    
                    self.next()
                }
            }
        }
        
        func pop() -> NavigationNotice? {
            if contents.count >= 1 {
                return contents.remove(at: 0)
            }
            return nil
        }
        
        func removeAll() {
            contents.removeAll()
        }
    }
    
    fileprivate var noticeViewController = ViewController()
    fileprivate var onStatusBar: Bool = NavigationNotice.defaultOnStatusBar
    fileprivate var completionHandler: (() -> Void)?
    /// Common navigation bar on the status bar. Default is `true`.
    open class var defaultOnStatusBar: Bool {
        set { sharedManager.onStatusBar = newValue }
        get { return sharedManager.onStatusBar }
    }
    fileprivate var showAnimations: ((@escaping () -> Void, @escaping (Bool) -> Void) -> Void)? = NavigationNotice.defaultShowAnimations
    /// Common animated block of show. Default is `nil`.
    open class var defaultShowAnimations: ((@escaping () -> Void, @escaping (Bool) -> Void) -> Void)? {
        set { sharedManager.showAnimations = newValue }
        get { return sharedManager.showAnimations }
    }
    fileprivate var hideAnimations: ((@escaping () -> Void, @escaping (Bool) -> Void) -> Void)? = NavigationNotice.defaultHideAnimations
    /// Common animated block of hide. Default is `nil`.
    open class var defaultHideAnimations: ((@escaping () -> Void, @escaping (Bool) -> Void) -> Void)? {
        set { sharedManager.hideAnimations = newValue }
        get { return sharedManager.hideAnimations }
    }
    fileprivate static let sharedManager = NoticeManager()
    
    /// Notification currently displayed.
    open class func currentNotice() -> NavigationNotice? {
        return sharedManager.showingNotice
    }
    
    /// Add content to display.
    open class func addContent(_ view: UIView) -> NavigationNotice {
        let notice = NavigationNotice()
        notice.noticeViewController.setContent(view)
        
        return notice
    }
    
    /// Set on the status bar of notification.
    open class func onStatusBar(_ on: Bool) -> NavigationNotice {
        let notice = NavigationNotice()
        notice.onStatusBar = on
        
        return notice
    }
    
    fileprivate init() {}
    
    /// Add content to display.
    open func addContent(_ view: UIView) -> Self {
        noticeViewController.setContent(view)
        
        if noticeViewController.targetView != nil {
            NavigationNotice.sharedManager.add(self)
        }
        
        return self
    }
    
    /// Show notification on view.
    open func showOn(_ view: UIView) -> Self {
        noticeViewController.showAnimations = showAnimations
        noticeViewController.hideAnimations = hideAnimations
        noticeViewController.targetView = view
        noticeViewController.hideCompletionHandler = { [weak self] in
            self?.completionHandler?()
            self?.completionHandler = nil
            NavigationNotice.sharedManager.next()
        }
        
        if noticeViewController.contentView != nil {
            NavigationNotice.sharedManager.add(self)
        }
        
        return self
    }
    
    /// Animated block of show.
    open func showAnimations(_ animations: @escaping (@escaping () -> Void, @escaping (Bool) -> Void) -> Void) -> Self {
        noticeViewController.showAnimations = animations
        
        return self
    }
    
    /// Hide notification.
    open func hide(_ interval: TimeInterval) {
        noticeViewController.setInterval(interval)
    }
    
    /// Animated block of hide.
    open func hideAnimations(_ animations: @escaping (@escaping () -> Void, @escaping (Bool) -> Void) -> Void) -> Self {
        noticeViewController.hideAnimations = animations
        
        return self
    }
    
    open func completion(_ completion: (() -> Void)?) {
        completionHandler = completion
    }
    
    /// Remove all notification.
    open func removeAll(_ hidden: Bool) -> Self {
        let notice = NavigationNotice.sharedManager
        notice.removeAll()
        
        if hidden {
            notice.showingNotice?.hide(0)
        }
        
        return self
    }
}
