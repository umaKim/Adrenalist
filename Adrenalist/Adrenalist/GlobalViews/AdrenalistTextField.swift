//
//  AdrenalistTextField.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/05/03.
//

import UIKit.UITextField

final class AdrenalistTextField: UITextField {
    private let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    
    init(placeHolder: String) {
        super.init(frame: .zero)
        
        self.placeholder = placeHolder
        layer.borderWidth = 1
        layer.borderColor = UIColor.pinkishRed.cgColor
        layer.cornerRadius = 12
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
