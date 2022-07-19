//
//  UIViewController+Ext.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/05/04.
//

import UIKit.UIView

extension UIViewController {
    var isModal: Bool {
        return self.presentingViewController?.presentedViewController == self
            || (self.navigationController != nil && self.navigationController?.presentingViewController?.presentedViewController == self.navigationController)
            || self.tabBarController?.presentingViewController is UITabBarController
    }
}
