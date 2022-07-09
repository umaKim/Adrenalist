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
}

final class AdrenalistTitleSetupModalView: UIView {
    
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private var actionSubject = PassthroughSubject<AdrenalistTitleSetupModalAction, Never>()
    
    private lazy var setupTitle: UILabel = {
       let lb = UILabel()
        lb.text = "Set name"
        return lb
    }()
    
    private lazy var titleTextField = AdrenalistTextField(placeHolder: "Title")
    
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
            .textPublisher
            .receive(on: RunLoop.main)
            .compactMap({$0})
            .sink { text in
                self.actionSubject.send(.titleDidChange(text))
            }
            .store(in: &cancellables)
        
        confirmButton.tapPublisher.sink { _ in
            self.actionSubject.send(.confirmDidTap)
        }
        .store(in: &cancellables)
        
        cancelButton.tapPublisher.sink { _ in
            self.actionSubject.send(.cancelDidTap)
        }
        .store(in: &cancellables)
    }
    
    private func setupUI() {
        layer.cornerRadius = 20
        
        backgroundColor = .blue
        let sv = UIStackView(arrangedSubviews: [setupTitle, titleTextField])
        sv.axis = .vertical
        sv.alignment = .fill
        sv.distribution = .fill
        
        let buttonSv = UIStackView(arrangedSubviews: [cancelButton, confirmButton])
        buttonSv.axis = .horizontal
        buttonSv.spacing = 12
        buttonSv.alignment = .fill
        buttonSv.distribution = .fillEqually
        
        [sv, buttonSv].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            sv.centerXAnchor.constraint(equalTo: centerXAnchor),
            sv.centerYAnchor.constraint(equalTo: centerYAnchor),
            buttonSv.topAnchor.constraint(equalTo: sv.bottomAnchor, constant: 8),
            buttonSv.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
