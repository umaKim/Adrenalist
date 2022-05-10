//
//  ItemSetupContainerView.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/05/09.
//

import UIKit
import Combine
import CombineCocoa

enum ItemSetupContainerViewAction {
    case confirm(Item)
    case cancel
}

final class ItemSetupContainerView: UIView {
    
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<ItemSetupContainerViewAction, Never>()
    
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
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupUI()
    }
    
    func updateUI(with item: Item?) {
        guard
            let item = item
        else { return }
        
        self.receivedWorkout = item
        
        switch item.type {
        case .workout:
            workoutView.updateUI(with: item)
        
        case .timer:
            timerView.updateUI(with: item)
        }
    }
    
    private func setupUI() {
        layer.cornerRadius = 12
        
        backgroundColor = .gray
        segmentController.selectedSegmentIndex = 0
        
        let buttonStack = UIStackView(arrangedSubviews: [confirmButton, cancelButton])
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.distribution = .fillEqually
        buttonStack.alignment = .fill
        buttonStack.axis = .horizontal
        buttonStack.spacing = 6
        
        [timerView, workoutView, segmentController, buttonStack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
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
            heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 1.5),
        ])
    }
    
    private var receivedWorkout: Item = Item(uuid: UUID(), timer: nil, title: "", reps: nil, weight: nil, isDone: false, type: .workout)
    
    private func bind() {
        workoutView
            .actionPublisher
            .sink {[weak self] action in
                guard let self = self else {return }
                
                switch action {
                case .workout(let title):
                    self.receivedWorkout.title = title
                
                case .reps(let reps):
                    self.receivedWorkout.reps = Int(reps) ?? 0
                    
                case .weight(let weight):
                    self.receivedWorkout.weight = Double(weight) ?? 0
                }

                self.receivedWorkout.type = .workout
            }
            .store(in: &cancellables)
        
        timerView
            .actionPublisher
            .sink {[weak self] action in
                guard let self = self else {return }
                switch action {
                case .time(let time):
                    self.receivedWorkout.timer = time
                    
                case .title(let title):
                    self.receivedWorkout.title = title
                }
                self.receivedWorkout.type = .timer
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
                guard
                    let self = self
                else { return }
                
                self.actionSubject.send(.confirm(self.receivedWorkout))
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
