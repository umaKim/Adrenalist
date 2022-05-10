//
//  WorkoutSetupView.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/05/05.
//
import Combine
import UIKit.UIView

enum WorkoutSetupViewAction {
    case total(String, String, String)
}

final class WorkoutSetupView: UIView {
    private lazy var workoutTextField = AdrenalistTextField(placeHolder: "workout")
    private lazy var repsTextField = AdrenalistTextField(placeHolder: "Reps")
    private lazy var weightTextField = AdrenalistTextField(placeHolder: "Weight")
    
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<WorkoutSetupViewAction, Never>()
    
    private var cancellbales: Set<AnyCancellable>
    
    init() {
        self.cancellbales = .init()
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .pinkishRed
        
        bind()
        setupUI()
    }
    
    func updateUI(with item: Item?) {
        workoutTextField.text = item?.title
        
        if let reps = item?.reps {
            repsTextField.text = "\(reps)"
        }
        
        if let weight = item?.weight {
            weightTextField.text = "\(weight)"
        }
    }
    
    private func bind() {
        workoutTextField.textPublisher
            .zip(repsTextField.textPublisher, weightTextField.textPublisher)
            .compactMap({ $0 as? (String, String, String) })
            .sink {[weak self] workout, reps, weight in
                guard let self = self else { return }
                self.actionSubject.send(.total(workout, reps, weight))
            }
            .store(in: &cancellbales)
    }
    
    private func setupUI() {
        let horizontalStackView = UIStackView(arrangedSubviews: [repsTextField, weightTextField])
        horizontalStackView.distribution = .fill
        horizontalStackView.alignment = .fill
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 6
        
        let verticalStackView = UIStackView (arrangedSubviews: [workoutTextField, horizontalStackView])
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.distribution = .fill
        verticalStackView.alignment = .fill
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 6
        
        addSubview(verticalStackView)
        
        NSLayoutConstraint.activate([
            verticalStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            verticalStackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
