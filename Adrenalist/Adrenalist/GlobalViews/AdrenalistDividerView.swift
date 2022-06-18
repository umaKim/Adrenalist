//
//  AdrenalistDividerView.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/06/18.
//

import UIKit

final class AdrenalistDividerView: UIView {
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .lightGray
        heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
