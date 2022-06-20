//
//  AdrenalistBottomNavigationBarView.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/06/20.
//

import UIKit

struct AdrenalistBottomNavigationBarViewConfigurator {
    let height: CGFloat
    let backgroundColor: UIColor
    
    init(height: CGFloat, backgroundColor: UIColor) {
        self.height = height
        self.backgroundColor = backgroundColor
    }
}

class AdrenalistBottomNavigationBarView: UIView {
    
//    private let buttons: [UIButton]
    private let uiViews: [UIView]
    
    init(with uiViews: [UIView],
         configurator: AdrenalistBottomNavigationBarViewConfigurator
    ) {
        self.uiViews = uiViews
        super.init(frame:
                .init(x: 0,
                      y: UIScreen.main.height,
                      width: UIScreen.main.width,
                      height: configurator.height))
        
        self.backgroundColor = configurator.backgroundColor
        
        setupUI()
    }
    
    private func setupUI() {
        let sv = UIStackView(arrangedSubviews: uiViews)
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = 8
        
        [sv].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            sv.leadingAnchor.constraint(equalTo: leadingAnchor),
            sv.topAnchor.constraint(equalTo: topAnchor),
            sv.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
