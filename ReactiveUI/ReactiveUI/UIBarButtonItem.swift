//
//  UIBarItem.swift
//  ReactiveControl
//
//  Created by Zhixuan Lai on 1/8/15.
//  Copyright (c) 2015 Zhixuan Lai. All rights reserved.
//

import UIKit

public extension UIBarButtonItem {
    
    convenience init(barButtonSystemItem systemItem: UIBarButtonItem.SystemItem, action: @escaping (UIBarButtonItem) -> ()) {
        self.init(barButtonSystemItem: systemItem, target: nil, action: nil)
        addAction(action)
    }
    
    convenience init(title: String?, style: UIBarButtonItem.Style, action: @escaping (UIBarButtonItem) -> ()) {
        self.init(title: title, style: style, target: nil, action: nil)
        addAction(action)
    }
    
    convenience init(image: UIImage?, style: UIBarButtonItem.Style, action: @escaping (UIBarButtonItem) -> ()) {
        self.init(image: image, style: style, target: nil, action: nil)
        addAction(action)
    }
    
    convenience init(image: UIImage?, landscapeImagePhone: UIImage?, style: UIBarButtonItem.Style, action: @escaping (UIBarButtonItem) -> ()) {
        self.init(image: image, landscapeImagePhone: landscapeImagePhone, style: style, target: nil, action: nil)
        addAction(action)
    }
    
    func addAction(_ action: @escaping (UIBarButtonItem) -> ()) {
        removeAction()

        proxyTarget = RUIBarButtonItemProxyTarget(action: action)
        target = proxyTarget
        self.action = RUIBarButtonItemProxyTarget.actionSelector()
    }
    
    func removeAction() {
        self.target = nil
        self.action = nil
    }
    
}

internal extension UIBarButtonItem {
    
    typealias RUIBarButtonItemProxyTargets = [String: RUIBarButtonItemProxyTarget]
    
    class RUIBarButtonItemProxyTarget: RUIProxyTarget {
        var action: (UIBarButtonItem) -> ()

        init(action: @escaping (UIBarButtonItem) -> ()) {
            self.action = action
        }

        @objc func performAction(control: UIBarButtonItem) {
            action(control)
        }
        
        override class func actionSelector() -> Selector {
            return #selector(RUIBarButtonItemProxyTarget.performAction)
        }
    }
    
    var proxyTarget: RUIBarButtonItemProxyTarget {
        get {
            if let targets = objc_getAssociatedObject(self, &RUIProxyTargetsKey) as? RUIBarButtonItemProxyTarget {
                return targets
            } else {
                return setProxyTargets(RUIBarButtonItemProxyTarget(action: {_ in}))
            }
        }
        set {
            setProxyTargets(newValue)
        }
    }
    
    private func setProxyTargets(_ newValue: RUIBarButtonItemProxyTarget) -> RUIBarButtonItemProxyTarget {
        objc_setAssociatedObject(self, &RUIProxyTargetsKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return newValue
    }
    
}
