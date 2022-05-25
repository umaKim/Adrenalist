//
//  InputView.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/05/26.
//

import UIKit

enum InputViewAction {
    case workoutTextFieldChange
    case repsFieldChange
    case weightFieldChange
    case addButton
}

final class InputView: UIView {
    
    private let workoutTextField = AdrenalistTextField(placeHolder: "workout")
    private let repsField = AdrenalistTextField(placeHolder: "Reps")
    private let weightField = AdrenalistTextField(placeHolder: "Weight")
    private let addButton = AdrenalistImageButton(image: UIImage(systemName: "plus"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        [workoutTextField, repsField, weightField].forEach { view in
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let stackView = UIStackView(arrangedSubviews: [workoutTextField, repsField, weightField, addButton])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
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
