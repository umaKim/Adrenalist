//
//  AdrenalistInputDetailView.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/06/17.
//

import Foundation
import UIKit

enum AdrenalistInputDetailViewAction {
    
}

class AdrenalistInputDetailView: UIView {
    
    private let reps = AdrenalistTextInputView(title: "Reps", placeholder: "reps")
    private let divider1 = AdrenalistDividerView()
    private let weight = AdrenalistTextInputView(title: "weight", placeholder: "weight")
    private let divider2 = AdrenalistDividerView()
    private let time = AdrenalistTextInputView(title: "time", placeholder: "time")
    private let divider3 = AdrenalistDividerView()
    private let set = AdrenalistInputStepperView(title: "Set", value: 0)
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .grey2
        
        layer.cornerRadius = 20
        
        let sv = UIStackView(arrangedSubviews: [reps, divider1, weight, divider2, time, divider3, set])
        sv.distribution = .equalCentering
        sv.alignment = .fill
        sv.axis = .vertical
        
        [sv].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            sv.centerXAnchor.constraint(equalTo: centerXAnchor),
            sv.centerYAnchor.constraint(equalTo: centerYAnchor),
            sv.leadingAnchor.constraint(equalTo: leadingAnchor),
            sv.trailingAnchor.constraint(equalTo: trailingAnchor),
            sv.topAnchor.constraint(equalTo: topAnchor),
            sv.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
