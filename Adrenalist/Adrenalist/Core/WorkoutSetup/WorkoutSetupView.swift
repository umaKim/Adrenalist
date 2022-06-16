//
//  WorkoutSetupView.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/06/16.
//

import CombineCocoa
import Combine
import UIKit

enum WorkoutSetupViewAction {
    case didTapDone
    case didTapCancel
}

class WorkoutSetupView: UIView {
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<WorkoutSetupViewAction, Never>()
    
    private(set) lazy var doneButton = UIBarButtonItem(title: "done", style: .plain, target: nil, action: nil)
    private(set) lazy var cancelButton: UIBarButtonItem = UIBarButtonItem(title: "cancel", style: .plain, target: nil, action: nil)
    
    private let titleTextFieldView = AdrenalistTitleView()
    
    private var cancellables: Set<AnyCancellable>
    
    init() {
        self.cancellables = .init()
        super.init(frame: .zero)
        
        bind()
        setupUI()
    }
    
    private func setupUI() {
        let totalStackView = UIStackView(arrangedSubviews: [titleTextFieldView])
        totalStackView.axis = .vertical
        totalStackView.alignment = .top
        totalStackView.distribution = .fill
        
        [totalStackView].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            totalStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            totalStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            totalStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            totalStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func bind() {
        doneButton
            .tapPublisher
            .sink { _ in
                self.actionSubject.send(.didTapDone)
            }
            .store(in: &cancellables)
        
        cancelButton
            .tapPublisher
            .sink { _ in
                self.actionSubject.send(.didTapCancel)
            }
            .store(in: &cancellables)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum AdrenalistTitleViewAction{
    case titleTextFieldDidChange(String)
    case isStarButtonSelected(Bool)
}

final class AdrenalistTitleView: UIView {
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<AdrenalistTitleViewAction, Never>()
    
    private let titleTextField: UITextField = {
       let lb = UITextField()
        lb.backgroundColor = .blue
        lb.text = "titleTextField"
        return lb
    }()
    
    private let starButton: UIButton = {
       let bt = UIButton()
        bt.setImage(UIImage(systemName: "star"), for: .normal)
        bt.backgroundColor = .gray
        return bt
    }()
    
    private var starStatus: Bool = false
    
    private var cancellables: Set<AnyCancellable>
    
    init() {
        self.cancellables = .init()
        super.init(frame: .zero)
        bind()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        titleTextField.textPublisher.sink { text in
            self.actionSubject.send(.titleTextFieldDidChange(text ?? ""))
        }
        .store(in: &cancellables)
        
        starButton.tapPublisher.sink { _ in
            self.starStatus.toggle()
            self.actionSubject.send(.isStarButtonSelected(self.starStatus))
        }
        .store(in: &cancellables)
    }
    
    private func setupUI() {
        let sv = UIStackView(arrangedSubviews: [titleTextField, starButton])
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.alignment = .fill
        
        [sv].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            sv.centerXAnchor.constraint(equalTo: centerXAnchor),
            sv.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
