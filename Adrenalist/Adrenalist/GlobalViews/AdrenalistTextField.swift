//
//  AdrenalistTextField.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/05/03.
//

import UIKit.UITextField

final class AdrenalistTextField: UITextField {
    init(placeHolder: String) {
        super.init(frame: .zero)
        
        self.placeholder = placeHolder
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
