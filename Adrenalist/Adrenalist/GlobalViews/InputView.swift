//
//  InputView.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/05/26.
//

import Combine
import CombineCocoa
import UIKit

enum InputViewAction {
    case addButton(String?, String?, String?)
}

final class InputView: UIView {
    
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<InputViewAction, Never>()
    
    private var cancellables: Set<AnyCancellable>
    
    private let workoutTextField    = AdrenalistTextField(placeHolder: "workout")
    private let repsField           = AdrenalistTextField(placeHolder: "Reps")
    private let weightField         = AdrenalistTextField(placeHolder: "Weight")
    private let addButton           = AdrenalistImageButton(image: UIImage(systemName: "plus"))
    
    override init(frame: CGRect) {
        self.cancellables = .init()
        super.init(frame: frame)
        
        bind
        setupUI
    }
    
    private var bind: Void {
        addButton
            .controlEventPublisher(for: .touchUpInside)
            .sink {[weak self] _ in
                self?.actionSubject.send(.addButton(self?.workoutTextField.text,
                                                    self?.repsField.text,
                                                    self?.weightField.text))
            }
            .store(in: &cancellables)
    }
    
    private var setupUI: Void {
        translatesAutoresizingMaskIntoConstraints = false
        
        [workoutTextField, repsField, weightField].forEach { view in
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        repsField.keyboardType = .numberPad
        weightField.keyboardType = .numberPad
        
        let stackView = UIStackView(arrangedSubviews: [workoutTextField, repsField, weightField, addButton])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            repsField.widthAnchor.constraint(equalToConstant: UIScreen.main.width / 5),
            weightField.widthAnchor.constraint(equalToConstant: UIScreen.main.width / 5),
            addButton.widthAnchor.constraint(equalToConstant: UIScreen.main.width / 8),
            
            self.heightAnchor.constraint(equalToConstant: 50),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
