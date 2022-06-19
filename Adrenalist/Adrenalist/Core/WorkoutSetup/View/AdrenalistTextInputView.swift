//
//  AdrenalistTextInputView.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/06/17.
//

import UIKit

class AdrenalistTextInputView: UIView {
    
    private let titleLabel: UILabel = {
       let lb = UILabel()
        lb.textColor = .white
        return lb
    }()
    
    private let textField: UITextField = {
       let tf = UITextField()
        tf.textColor = .white
        tf.widthAnchor.constraint(equalToConstant: 100).isActive = true
        return tf
    }()
    
    init(
        title: String,
        placeholder: String
    ) {
        self.titleLabel.text = title
        self.textField.placeholder = placeholder
        super.init(frame: .zero)
        
        setupUI()
    }
    
    private func setupUI() {
        layer.cornerRadius = 20
        
        let sv = UIStackView(arrangedSubviews: [titleLabel, textField])
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.alignment = .fill
        
        [sv].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
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


