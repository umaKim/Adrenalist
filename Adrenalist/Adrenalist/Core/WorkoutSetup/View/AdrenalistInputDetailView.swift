//
//  AdrenalistInputDetailView.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/06/17.
//

import Combine
import CombineCocoa
import UIKit

enum AdrenalistInputDetailViewAction {
    case repsDidChange(String)
    case weightDidChange(String)
    case timeDidChange(String)
    case setDidChange(String)
}

class AdrenalistInputDetailView: UIView {
    
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<AdrenalistInputDetailViewAction, Never>()
    
    private let reps = AdrenalistTextInputView(title: "Reps", placeholder: "reps", keyboardType: .numberPad)
    private let divider1 = AdrenalistDividerView()
    
    private lazy var weight = AdrenalistTextInputView(title: "weight",
                                                 placeholder: "weight",
                                                      keyboardType: .numberPad)
    private let divider2 = AdrenalistDividerView()
    
    private let time = AdrenalistTextInputView(title: "time",
                                               placeholder: "time",
                                               keyboardType: .numberPad)
    private let divider3 = AdrenalistDividerView()
    
    private let set = AdrenalistInputStepperView(title: "Set", value: 1)
    
    func setupReps(_ reps: Int) {
        self.reps.setupValue("\(reps)")
    }
    
    func setupWeight(_ weight: Double) {
        self.weight.setupValue("\(weight)")
    }
    
    func setupTime(_ timer: TimeInterval) {
        self.time.setupValue("\(timer)")
    }
    
    private let type: WorkoutSetupType
    
    init(type: WorkoutSetupType) {
        self.type = type
        self.cancellables = .init()
        super.init(frame: .zero)
        
        switch type {
        case .edit:
            self.set.isHidden = true
            
        case .add:
            self.set.isHidden = false
        }
        
        bind()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var cancellables: Set<AnyCancellable>
    
    private func bind() {
        reps.actionPublisher.sink { action in
            switch action {
            case .textFieldDidChange(let text):
                self.actionSubject.send(.repsDidChange(text))
            }
        }
        .store(in: &cancellables)
        
        weight.actionPublisher.sink { action in
            switch action {
            case .textFieldDidChange(let text):
                self.actionSubject.send(.weightDidChange(text))
            }
        }
        .store(in: &cancellables)
        
        time.actionPublisher.sink { action in
            switch action {
            case .textFieldDidChange(let text):
                self.actionSubject.send(.timeDidChange(text))
            }
        }
        .store(in: &cancellables)
        
        set.actionPublisher.sink { action in
            switch action {
            case .valueDidChange(let value):
                self.actionSubject.send(.setDidChange(value))
            }
        }
        .store(in: &cancellables)
    }
    
    private func setupUI() {
        backgroundColor = .grey2
        
        layer.cornerRadius = 20
        
        let sv = UIStackView(arrangedSubviews: [reps, divider1, weight, divider2, time, divider3, set])
        sv.distribution = .equalCentering
        sv.alignment = .fill
        sv.axis = .vertical
        
        [sv].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            sv.centerXAnchor.constraint(equalTo: centerXAnchor),
            sv.centerYAnchor.constraint(equalTo: centerYAnchor),
            sv.leadingAnchor.constraint(equalTo: leadingAnchor),
            sv.trailingAnchor.constraint(equalTo: trailingAnchor),
            sv.topAnchor.constraint(equalTo: topAnchor),
//            sv.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
