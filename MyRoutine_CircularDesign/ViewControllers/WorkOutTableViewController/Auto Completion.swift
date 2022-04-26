//
//  Auto Completion.swift
//  MyRoutine_CircularDesign
//
//  Created by 김윤석 on 2021/04/06.
//

import Foundation
import UIKit

//auto completion
extension WorkOutTableViewController {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return !autoCompleteText( in : textField, using: string, suggestionsArray: workoutSuggestions )
    }
    
    func autoCompleteText( in textField: UITextField, using string: String, suggestionsArray: [String]) -> Bool {
        if !string.isEmpty,
           let selectedTextRange = textField.selectedTextRange,
           selectedTextRange.end == textField.endOfDocument,
           let prefixRange = textField.textRange(from: textField.beginningOfDocument, to: selectedTextRange.start),
           let text = textField.text( in : prefixRange) {
            
            let prefix = text + string
            let matches = suggestionsArray.filter { return $0.hasPrefix(prefix) }
            
            if (matches.count > 0) {
                textField.text = matches[0]
                if let start = textField.position(from: textField.beginningOfDocument, offset: prefix.count) {
                    textField.selectedTextRange = textField.textRange(from: start, to: textField.endOfDocument)
                    return true
                }
            }
        }
        return false
    }
}
