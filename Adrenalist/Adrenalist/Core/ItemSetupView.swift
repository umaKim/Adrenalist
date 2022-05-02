//
//  ItemSetupView.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/05/02.
//

import UIKit

final class ItemSetupViewMediator: UIView {
    
    
}

final class WorkoutSetupView: UIView {
    private lazy var workoutLabel: UILabel = {
       let lb = UILabel()
        return lb
    }()
    
    private lazy var repsLabel: UILabel = {
        let lb = UILabel()
        
        return lb
    }()
    
    private lazy var countLabel: UILabel = {
       let lb = UILabel()
        return lb
    }()
    
    init() {
        super.init(frame: .zero)
        
        let stackView = UIStackView (arrangedSubviews: [workoutLabel, repsLabel, countLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 6
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            widthAnchor.constraint(equalToConstant: 200),
            heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class TimerSetupView: UIView {
    
}
