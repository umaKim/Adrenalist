//
//  ItemSetupView.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/05/03.
//

import CombineCocoa
import Combine
import UIKit.UIView

enum WorkoutSetupViewAction {
    case confirm(Workout)
    case cancel
}

final class WorkoutSetupView: UIView {
    
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<WorkoutSetupViewAction, Never>()
    
    private lazy var workoutTextField = AdrenalistTextField(placeHolder: "workout")
    private lazy var repsTextField = AdrenalistTextField(placeHolder: "Reps")
    private lazy var weightTextField = AdrenalistTextField(placeHolder: "Count")
    
    private lazy var confirmButton = AdrenalistButton(title: "Confirm")
    private lazy var cancelButton = AdrenalistButton(title: "Cancel")
    
    private var cancellables: Set<AnyCancellable>
    
    init() {
        self.cancellables = .init()
        super.init(frame: .zero)
        
        bind()
        setupUI()
    }
    
    private func bind() {
        cancelButton
            .tapPublisher
            .sink { _ in
                self.actionSubject.send(.cancel)
            }
            .store(in: &cancellables)
        
        confirmButton
            .tapPublisher
            .sink { _ in
                let workout = Workout(title: self.workoutTextField.text ?? "",
                                      reps: Int(self.repsTextField.text ?? "0") ?? 0,
                                      weight: Double(self.weightTextField.text ?? "0") ?? 0,
                                      isDone: false)
                self.actionSubject.send(.confirm(workout))
            }
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .gray
        
        let stackView = UIStackView (arrangedSubviews: [workoutTextField, repsTextField, weightTextField])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 6
        
        let buttonStack = UIStackView(arrangedSubviews: [confirmButton, cancelButton])
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.distribution = .fillEqually
        buttonStack.alignment = .fill
        buttonStack.axis = .horizontal
        buttonStack.spacing = 6
        
        addSubview(stackView)
        addSubview(buttonStack)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            buttonStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            buttonStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            widthAnchor.constraint(equalToConstant: 200),
            heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
