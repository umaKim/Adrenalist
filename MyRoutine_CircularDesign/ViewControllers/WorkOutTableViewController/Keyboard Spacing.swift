//
//  Keyboard Spacing.swift
//  MyRoutine_CircularDesign
//
//  Created by 김윤석 on 2021/04/06.
//

import Foundation
import UIKit

//KeyBoard view spacing
extension WorkOutTableViewController {
    @objc func keyboardWillShow(_ notification: Notification) { 
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            viewBottomSpace.constant = keyboardHeight
            tableViewBottomSpace.constant = keyboardHeight + viewHeight.constant
        }
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        viewBottomSpace.constant = viewHeight.constant
        tableViewBottomSpace.constant = viewHeight.constant
        enterWorkOutTextField.resignFirstResponder()
    }
    
    @objc func adjustInputView(noti: Notification) {
        guard let userInfo = noti.userInfo else { return }
        // [x] TODO: 키보드 높이에 따른 인풋뷰 위치 변경
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        if noti.name == UIResponder.keyboardWillShowNotification {
            let adjustmentHeight = keyboardFrame.height - view.safeAreaInsets.bottom
            tableViewBottomSpace.constant = adjustmentHeight + viewHeight.constant
            viewBottomSpace.constant = adjustmentHeight
            //suggestionView.isHidden = true
            
        } else {
            tableViewBottomSpace.constant = viewHeight.constant
            viewBottomSpace.constant = 0
            //suggestionView.isHidden = true
        }
    }
}
