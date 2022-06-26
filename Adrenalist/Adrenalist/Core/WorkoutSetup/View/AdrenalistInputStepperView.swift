//
//  AdrenalistInputStepperView.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/06/17.
//
import Combine
import CombineCocoa
import UIKit

enum AdrenalistInputStepperViewAction {
    case valueDidChange(String)
}

class AdrenalistInputStepperView: UIView {
    
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<AdrenalistInputStepperViewAction, Never>()
    
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
    
    private var currentValue = CurrentValueSubject<Int, Never>(0)
    private var value: Int = 0
    
    private var cancellables: Set<AnyCancellable>
    
    init(
        title: String,
        value: Int
    ) {
        self.titleLabel.text = title
        self.currentValue = CurrentValueSubject<Int, Never>(value)
        self.value = value
        self.cancellables = .init()
        super.init(frame: .zero)
        
        bind()
        setupUI()
    }
    
    private func bind() {
        addButton.tapPublisher.sink { _ in
            self.value += 1
            self.currentValue.send(self.value)
        }
        .store(in: &cancellables)
        
        subButton.tapPublisher.sink { _ in
            self.value -= 1
            self.currentValue.send(self.value)
        }
        .store(in: &cancellables)
        
        currentValue.sink { value in
            self.actionSubject.send(.valueDidChange("\(value)"))
            self.valueLabel.text = "\(value)"
        }
        .store(in: &cancellables)
    }
    
    private func setupUI() {
        layer.cornerRadius = 20
        
        let hv = UIStackView(arrangedSubviews: [subButton ,valueLabel, addButton])
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


