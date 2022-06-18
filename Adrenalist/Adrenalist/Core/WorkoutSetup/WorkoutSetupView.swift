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
    
    private(set) lazy var doneButton = UIBarButtonItem(title: "Done", style: .plain, target: nil, action: nil)
    private(set) lazy var cancelButton: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: nil)
    
    private let titleTextFieldView = AdrenalistTitleView()
    private let adrenalistInputDetailView = AdrenalistInputDetailView()
    
    private var cancellables: Set<AnyCancellable>
    
    init() {
        self.cancellables = .init()
        super.init(frame: .zero)
        
        bind()
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .darkNavy
        
        
        [titleTextFieldView, adrenalistInputDetailView]
            .forEach { uv in
                uv.translatesAutoresizingMaskIntoConstraints = false
                addSubview(uv)
            }
        
        NSLayoutConstraint.activate([
            titleTextFieldView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            titleTextFieldView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleTextFieldView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            titleTextFieldView.heightAnchor.constraint(equalToConstant: 64),
            
            adrenalistInputDetailView.topAnchor.constraint(equalTo: titleTextFieldView.bottomAnchor, constant: 32),
            adrenalistInputDetailView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            adrenalistInputDetailView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            adrenalistInputDetailView.heightAnchor.constraint(equalToConstant: 244)
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
