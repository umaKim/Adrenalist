//
//  AdrenalistCircleButton.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/05/03.
//

import UIKit.UIButton

final class AdrenalistCircleButton: UIButton {

    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    private func setupUI() {
        let image = self.isSelected ? UIImage(systemName: "circle") : UIImage(systemName: "circle.fill")
        setImage(image, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
