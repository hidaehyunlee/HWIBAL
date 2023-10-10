//
//  RootView.swift
//  HWIBAL
//
//  Created by daelee on 10/10/23.
//

import UIKit

protocol RootView: UIView {
    func initializeUI()
}

fileprivate enum AssociatedKeys {
    static var viewControllerKey = "ViewControllerKey"
}

extension RootView {
    var viewController: UIViewController? {
        get {
            withUnsafePointer(to: &AssociatedKeys.viewControllerKey) { pointer in
                objc_getAssociatedObject(self, pointer) as? UIViewController
            }
        }
        set {
            withUnsafePointer(to: &AssociatedKeys.viewControllerKey) { pointer in
                objc_setAssociatedObject(self, pointer, newValue, .OBJC_ASSOCIATION_ASSIGN)
            }
        }
    }
}
