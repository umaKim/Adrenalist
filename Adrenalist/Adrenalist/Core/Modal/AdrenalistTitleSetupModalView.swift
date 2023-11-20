//
//  AdrenalistTitleSetupView.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/07/07.
//

import CombineCocoa
import Combine
import UIKit

enum AdrenalistTitleSetupModalAction {
    case titleDidChange(String)
    case confirmDidTap
    case cancelDidTap
    case titleTextFieldDidTapDone
}

final class AdrenalistTitleSetupModalView: UIView {
    
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private var actionSubject = PassthroughSubject<AdrenalistTitleSetupModalAction, Never>()
    
    private lazy var setupTitle: UILabel = {
       let lb = UILabel()
        lb.text = "Create set"
        lb.textColor = .white
        return lb
    }()
    
    private lazy var titleTextField: AdrenalistTitleView = {
       let tv = AdrenalistTitleView(placeholder: "Set name")
        tv.heightAnchor.constraint(equalToConstant: 64).isActive = true
        return tv
    }()
    
    private lazy var confirmButton: AdrenalistTextRectangleButton = {
        let bt = AdrenalistTextRectangleButton(title: "confirm")
        bt.widthAnchor.constraint(equalToConstant: UIScreen.main.width / 3).isActive = true
        return bt
    }()
    
    private lazy var cancelButton: AdrenalistTextRectangleButton = {
        let bt = AdrenalistTextRectangleButton(title: "cancel")
        bt.widthAnchor.constraint(equalToConstant: UIScreen.main.width / 3).isActive = true
        return bt
    }()
    
    private var cancellables: Set<AnyCancellable>
    
    init() {
        self.cancellables = .init()
        super.init(frame: .zero)
        
        bind()
        setupUI()
    }
    
    private func bind() {
        titleTextField
            .actionPublisher
            .sink {[weak self] action in
                guard let self = self else { return }
                switch action {
                case .titleTextFieldDidChange(let text):
                    self.actionSubject.send(.titleDidChange(text))
                    
                case .done:
                    self.actionSubject.send(.titleTextFieldDidTapDone)
                }
            }
            .store(in: &cancellables)
        
        confirmButton
            .tapPublisher
            .sink {[weak self] _ in
                guard let self = self else { return }
                self.actionSubject.send(.confirmDidTap)
            }
            .store(in: &cancellables)
        
        cancelButton
            .tapPublisher
            .sink {[weak self] _ in
                guard let self = self else { return }
                self.actionSubject.send(.cancelDidTap)
            }
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        layer.cornerRadius = 20
        backgroundColor = .darkNavy
        
        let titleSv = UIStackView(arrangedSubviews: [setupTitle])
        titleSv.axis = .vertical
        titleSv.spacing = 12
        titleSv.alignment = .center
        titleSv.distribution = .fillEqually
        
        let buttonSv = UIStackView(arrangedSubviews: [cancelButton, confirmButton])
        buttonSv.axis = .horizontal
        buttonSv.spacing = 12
        buttonSv.alignment = .fill
        buttonSv.distribution = .fillEqually
        
        let totalSv = UIStackView(arrangedSubviews: [titleSv, titleTextField, buttonSv])
        totalSv.axis = .vertical
        totalSv.spacing = 16
        totalSv.alignment = .fill
        totalSv.distribution = .fill
        
        [totalSv].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        totalSv.backgroundColor = .red
        
        NSLayoutConstraint.activate([
            totalSv.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            totalSv.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            totalSv.centerXAnchor.constraint(equalTo: centerXAnchor),
            totalSv.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
