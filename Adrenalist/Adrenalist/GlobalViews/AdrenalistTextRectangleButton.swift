//
//  AdrenalistTextRectangleButton.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/06/19.
//

import Foundation
import UIKit

final class AdrenalistTextRectangleButton: UIButton {
    
    init(title: String, textColor: UIColor = .white, backgroundColor: UIColor = .purpleBlue, cornerRadius: CGFloat = 20) {
        super.init(frame: .zero)
        
        self.setTitle(title, for: .normal)
        self.tintColor = textColor
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = cornerRadius
        
//        self.widthAnchor.constraint(equalToConstant: UIScreen.main.width - 32).isActive = true
        self.heightAnchor.constraint(equalToConstant: 64).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
