//
//  UIView.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/07/19.
//

import Foundation

extension UIView {
    func addTapGestureToViewForKeyboardDismiss() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        addGestureRecognizer(tap)
    }
}
