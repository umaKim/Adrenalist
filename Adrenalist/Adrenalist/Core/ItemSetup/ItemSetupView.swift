//
//  ItemSetupView.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/05/03.
//

import CombineCocoa
import Combine
import UIKit.UIView

enum ItemType: String, Codable {
    case workout = "Workout"
    case timer = "Timer"
}

enum ItemSetupViewAction {
    case confirm(Item)
    case cancel
}

final class ItemSetupView: UIView {
    
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<ItemSetupViewAction, Never>()
    
    private let workoutView = WorkoutSetupView()
    private let timerView = TimerSetupView()
    
    private lazy var segmentController = UISegmentedControl(items: [ItemType.workout.rawValue, ItemType.timer.rawValue])
    
    private lazy var confirmButton = AdrenalistButton(title: "Confirm")
    private lazy var cancelButton = AdrenalistButton(title: "Cancel")
    
    private var cancellables: Set<AnyCancellable>
    
    init() {
        self.cancellables = .init()
        super.init(frame: .zero)
        
        bind()
        setupUI()
        
    }
    
    private var workout = Item(title: "", isDone: false, type: .workout)
    
    private func bind() {
        workoutView
            .actionPublisher
            .sink {[weak self] action in
                guard let self = self else {return }
                switch action {
                case .total(let title, let reps, let weight):
                    self.workout.title = title
                    self.workout.reps = Int(reps) ?? 0
                    self.workout.weight = Double(weight) ?? 0
                }
                self.workout.type = .workout
            }
            .store(in: &cancellables)
        
        timerView
            .actionPublisher
            .sink {[weak self] action in
                guard let self = self else {return }
                switch action {
                case .time(let time):
                    self.workout.timer = time
                    
                case .title(let title):
                    self.workout.title = title
                }
                self.workout.type = .timer
            }
            .store(in: &cancellables)
        
        segmentController
            .selectedSegmentIndexPublisher
            .sink {[weak self] index in
                guard let self = self else {return }
                switch index {
                case 0:
                    self.workoutView.isHidden = false
                    self.timerView.isHidden = true
                    
                case 1:
                    self.workoutView.isHidden = true
                    self.timerView.isHidden = false
                    
                default:
                    self.workoutView.isHidden = false
                    self.timerView.isHidden = true
                }
            }
            .store(in: &cancellables)
        
        confirmButton
            .tapPublisher
            .sink {[weak self] _ in
                guard let self = self else {return }
                self.actionSubject.send(.confirm(self.workout))
            }
            .store(in: &cancellables)
        
        cancelButton
            .tapPublisher
            .sink {[weak self] _ in
                guard let self = self else {return }
                self.actionSubject.send(.cancel)
            }
            .store(in: &cancellables)
    }
    
    private var selectedItemType: ItemType {
        segmentController.selectedSegmentIndex == 0 ? .workout : .timer
    }
    
    private func setupUI() {
        layer.cornerRadius = 12
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .gray
        
        segmentController.translatesAutoresizingMaskIntoConstraints = false
        segmentController.selectedSegmentIndex = 0
        
        let buttonStack = UIStackView(arrangedSubviews: [confirmButton, cancelButton])
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.distribution = .fillEqually
        buttonStack.alignment = .fill
        buttonStack.axis = .horizontal
        buttonStack.spacing = 6
        
        addSubview(timerView)
        addSubview(workoutView)
        addSubview(segmentController)
        addSubview(buttonStack)
        
        NSLayoutConstraint.activate([
            timerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            timerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6),
            timerView.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            timerView.bottomAnchor.constraint(equalTo: segmentController.topAnchor),
            
            workoutView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            workoutView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6),
            workoutView.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            workoutView.bottomAnchor.constraint(equalTo: segmentController.topAnchor),
            
            segmentController.centerXAnchor.constraint(equalTo: centerXAnchor),
            segmentController.bottomAnchor.constraint(equalTo: buttonStack.topAnchor),
            
            buttonStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            buttonStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 1.5),
            heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 1.5)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
