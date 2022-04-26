//
//  Gesture.swift
//  MyRoutine_CircularDesign
//
//  Created by 김윤석 on 2021/04/07.
//

import UIKit
//Gestures
extension WorkOutTableViewController {
    func pressCellToEdit() {
        tableView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(cellDidPressed)))
    }
    
    func tapCellToReleaseKeyBoardAndNotToEdit() {
        tableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cellDidTapped)))
    }
    
    @objc func cellDidPressed(sender: UIView) {
        tableView.isEditing = true
        //deleteAllButton.isHidden = false
        HapticManager.shared.vibrateForImpactFeedback(intensity: 1.0)
    }
    
    @objc func cellDidTapped(sender: UIView) {
        tableView.isEditing = false
        //deleteAllButton.isHidden = true
        enterWorkOutTextField.resignFirstResponder()
        enterRepsTextField.resignFirstResponder()
        enterWeightsTextField.resignFirstResponder()
        
        enterWorkOutTextField.text = ""
        enterRepsTextField.text = ""
        enterWeightsTextField.text = ""
    }
}
