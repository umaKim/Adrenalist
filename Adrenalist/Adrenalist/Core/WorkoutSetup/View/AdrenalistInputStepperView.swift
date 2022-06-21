//
//  AdrenalistInputStepperView.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/06/17.
//

import UIKit

class AdrenalistInputStepperView: UIView {
    
    private let titleLabel: UILabel = {
       let lb = UILabel()
        lb.textColor = .white
        return lb
    }()
    
    private let addButton: UIButton = {
       let bt = UIButton()
        bt.setImage(UIImage(systemName: "plus"), for: .normal)
        bt.tintColor = .white
        bt.widthAnchor.constraint(equalToConstant: 32).isActive = true
        bt.heightAnchor.constraint(equalToConstant: 32).isActive = true
        return bt
    }()
    
    private let valueLabel: UILabel = {
       let lb = UILabel()
        lb.textColor = .white
        return lb
    }()
    
    private let subButton: UIButton = {
       let bt = UIButton()
        bt.setImage(UIImage(systemName: "minus"), for: .normal)
        bt.tintColor = .white
        bt.widthAnchor.constraint(equalToConstant: 32).isActive = true
        bt.heightAnchor.constraint(equalToConstant: 32).isActive = true
        return bt
    }()
    
    init(
        title: String,
        value: Int
    ) {
        self.titleLabel.text = title
        self.valueLabel.text = "\(value)"
        super.init(frame: .zero)
        
        setupUI()
    }
    
    private func setupUI() {
        layer.cornerRadius = 20
        
        let hv = UIStackView(arrangedSubviews: [addButton ,valueLabel, subButton])
        hv.axis = .horizontal
        hv.alignment = .firstBaseline
        hv.distribution = .equalCentering
        hv.spacing = 8
        hv.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        let sv = UIStackView(arrangedSubviews: [titleLabel, hv])
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.alignment = .fill
        
        [sv].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
//            sv.centerXAnchor.constraint(equalTo: centerXAnchor),
            sv.centerYAnchor.constraint(equalTo: centerYAnchor),
            sv.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            sv.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
        
        heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

