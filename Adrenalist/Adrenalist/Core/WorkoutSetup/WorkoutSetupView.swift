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
    
    case titleDidChange(String)
    case isFavorite(Bool)
    case repsDidChange(String)
    case weightDidChange(String)
    case timeDidChange(String)
    case setDidChange(String)
}

class WorkoutSetupView: UIView {
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<WorkoutSetupViewAction, Never>()
    
    private(set) lazy var doneButton: UIBarButtonItem = {
        let bt = UIBarButtonItem(title: "Done", style: .plain, target: nil, action: nil)
        bt.tintColor = .purpleBlue
        return bt
    }()
    
    private(set) lazy var cancelButton: UIBarButtonItem = {
       let bt = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: nil)
        bt.tintColor = .purpleBlue
        return bt
    }()
    
    private let titleTextFieldView = AdrenalistTitleView()
    private let adrenalistInputDetailView: AdrenalistInputDetailView
    
    private var cancellables: Set<AnyCancellable>
    
    init(type: WorkoutSetupType) {
        self.adrenalistInputDetailView = AdrenalistInputDetailView(type: type)
        self.cancellables = .init()
        super.init(frame: .zero)
        backgroundColor = .darkNavy
        
        bind()
        setupUI()
    }
    
    func setUpReceivedModel(model: WorkoutModel) {
        titleTextFieldView.setupTitleTextField(model.title)
        adrenalistInputDetailView.setupReps(model.reps ?? 0)
        adrenalistInputDetailView.setupWeight(model.weight ?? 0)
        adrenalistInputDetailView.setupTime(model.timer ?? 0)
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
        
        titleTextFieldView
            .actionPublisher
            .sink { action in
                switch action {
                case .titleTextFieldDidChange(let text):
                    self.actionSubject.send(.titleDidChange(text))
                    
                case .isStarButtonSelected(let isFavorite):
                    self.actionSubject.send(.isFavorite(isFavorite))
                }
            }
            .store(in: &cancellables)
        
        adrenalistInputDetailView
            .actionPublisher
            .sink { action in
                switch action {
                case .repsDidChange(let text):
                    self.actionSubject.send(.repsDidChange(text))
                    
                case .weightDidChange(let text):
                    self.actionSubject.send(.weightDidChange(text))
                    
                case .timeDidChange(let text):
                    self.actionSubject.send(.timeDidChange(text))
                    
                case .setDidChange(let text):
                    self.actionSubject.send(.setDidChange(text))
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        [titleTextFieldView, adrenalistInputDetailView]
            .forEach { uv in
                uv.translatesAutoresizingMaskIntoConstraints = false
                addSubview(uv)
            }
        
        NSLayoutConstraint.activate([
            titleTextFieldView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 31.5),
            titleTextFieldView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleTextFieldView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            titleTextFieldView.heightAnchor.constraint(equalToConstant: 64),
            
            adrenalistInputDetailView.topAnchor.constraint(equalTo: titleTextFieldView.bottomAnchor, constant: 32),
            adrenalistInputDetailView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            adrenalistInputDetailView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
