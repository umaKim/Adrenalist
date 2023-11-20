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
    
    case titleTextFieldViewDidTapDone
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
    
    private let contentScrollView: UIScrollView = {
       let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        return sv
    }()
    private let contentView = UIView()
    private let titleTextFieldView = AdrenalistTitleView(placeholder: "Workout")
    private let adrenalistInputDetailView: AdrenalistInputDetailView
    
    private var cancellables: Set<AnyCancellable>
    
    init(type: WorkoutSetupType) {
        self.adrenalistInputDetailView = AdrenalistInputDetailView(type: type)
        self.cancellables = .init()
        super.init(frame: .zero)
        
        bind()
        setupUI()
    }
    
    func setUpReceivedModel(model: WorkoutModel) {
        titleTextFieldView.setupTitleTextField(model.title)
        adrenalistInputDetailView.setupReps(model.reps)
        adrenalistInputDetailView.setupWeight(model.weight)
        adrenalistInputDetailView.setupTime(model.timer)
    }
    
    private func bind() {
        doneButton
            .tapPublisher
            .sink {[weak self] _ in
                guard let self = self else { return }
                self.actionSubject.send(.didTapDone)
            }
            .store(in: &cancellables)
        
        cancelButton
            .tapPublisher
            .sink {[weak self] _ in
                guard let self = self else { return }
                self.actionSubject.send(.didTapCancel)
            }
            .store(in: &cancellables)
        
        titleTextFieldView
            .actionPublisher
            .sink {[weak self] action in
                guard let self = self else { return }
                switch action {
                case .titleTextFieldDidChange(let text):
                    self.actionSubject.send(.titleDidChange(text))
                    
                case .done:
                    self.actionSubject.send(.titleTextFieldViewDidTapDone)
                }
            }
            .store(in: &cancellables)
        
        adrenalistInputDetailView
            .actionPublisher
            .sink {[weak self] action in
                guard let self = self else { return }
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
        backgroundColor = .darkNavy
        
        addSubview(contentScrollView)
        contentScrollView.addSubview(contentView)
        
        contentScrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        [titleTextFieldView, adrenalistInputDetailView].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            contentScrollView.topAnchor.constraint(equalTo: topAnchor),
            contentScrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentScrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentScrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: contentScrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: contentScrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: contentScrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: contentScrollView.bottomAnchor),
            
            contentView.widthAnchor.constraint(equalTo: contentScrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: UIScreen.main.height * 1.00005),
            
            titleTextFieldView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 31.5),
            titleTextFieldView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleTextFieldView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleTextFieldView.heightAnchor.constraint(equalToConstant: 64),
            
            adrenalistInputDetailView.topAnchor.constraint(equalTo: titleTextFieldView.bottomAnchor, constant: 32),
            adrenalistInputDetailView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            adrenalistInputDetailView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
