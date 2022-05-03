//
//  AdrenalistLabel.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/05/03.
//

import UIKit.UILabel

final class AdrenalistLabel: UILabel {
    init(text: String) {
        super.init(frame: .zero)
        self.text = text
        
        setupUI()
    }
    
    private func setupUI() {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
