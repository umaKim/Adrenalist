//
//  UIViewController+Ext.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/05/04.
//

import UIKit.UIView

extension UIView {
    func addTapGestureToViewForKeyboardDismiss() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        addGestureRecognizer(tap)
    }
}

