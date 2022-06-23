//
//  AdrenalistTextInputView.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/06/17.
//
import Combine
import CombineCocoa
import UIKit

enum AdrenalistTextInputViewAction {
    case textFieldDidChange(String)
}

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
    
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<AdrenalistTextInputViewAction, Never>()
    
    private var cancellables: Set<AnyCancellable>
    
    init(
        title: String,
        placeholder: String
    ) {
        self.titleLabel.text = title
        self.textField.placeholder = placeholder
        self.cancellables = .init()
        super.init(frame: .zero)
        
        bind()
        setupUI()
    }
    
    private func bind() {
        textField.textPublisher
            .compactMap({$0})
            .sink { text in
            self.actionSubject.send(.textFieldDidChange(text))
        }
        .store(in: &cancellables)
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


