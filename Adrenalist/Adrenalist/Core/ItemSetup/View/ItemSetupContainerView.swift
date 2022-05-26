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
    
    private let workoutView     = WorkoutSetupView()
    private let timerView       = TimerSetupView()
    
    private lazy var segmentController = UISegmentedControl(items: [ItemType.workout.rawValue, ItemType.timer.rawValue])
    
    private lazy var confirmButton  = AdrenalistButton(title: "Confirm")
    private lazy var cancelButton   = AdrenalistButton(title: "Cancel")

    private lazy var switcher = CurrentValueSubject<Bool, Never>(true)
    
    private var cancellables: Set<AnyCancellable>
    
    init() {
        self.cancellables = .init()
        super.init(frame: .zero)
        segmentController.selectedSegmentIndex = 0
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
            segmentController.selectedSegmentIndex = 0
            
        case .timer:
            segmentController.selectedSegmentIndex = 1
        }
        
        workoutView.updateUI(with: item)
        timerView.updateUI(with: item)
    }
    
    private func setupUI() {
        layer.cornerRadius = 12
        
        backgroundColor = .gray
        
        let buttonStack = UIStackView(arrangedSubviews: [cancelButton, confirmButton])
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.distribution = .fillEqually
        buttonStack.alignment = .fill
        buttonStack.axis = .horizontal
        buttonStack.spacing = 16
        
        let totalStack = UIStackView(arrangedSubviews: [timerView, workoutView, segmentController, buttonStack])
        totalStack.translatesAutoresizingMaskIntoConstraints = false
        totalStack.distribution = .fillProportionally
        totalStack.alignment = .fill
        totalStack.axis = .vertical
        totalStack.spacing = 8
        
        addSubview(totalStack)
        
        NSLayoutConstraint.activate([
            segmentController.widthAnchor.constraint(equalToConstant: UIScreen.main.width/2),
            
            totalStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            totalStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6),
            totalStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6),
            totalStack.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            
            widthAnchor.constraint(equalToConstant: UIScreen.main.width / 1.5),
            heightAnchor.constraint(equalToConstant: UIScreen.main.width / 2.2),
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
                    self.receivedWorkout.timer = time == 0 ? nil : time
                    
                case .title(let title):
                    self.receivedWorkout.title = title
                }
                
                self.receivedWorkout.type = .timer
            }
            .store(in: &cancellables)
        
        segmentController
            .selectedSegmentIndexPublisher
            .sink {[weak self] index in
                guard let self = self else { return }
                    switch index {
                    case 0:
                        self.switcher.send(false)

                    case 1:
                        self.switcher.send(true)

                    default:
                        self.switcher.send(false)
                    }
            }
            .store(in: &cancellables)
        
        switcher
            .assign(to: \.isHidden, on: workoutView, animation: .fade(duration: 0.5))
            .store(in: &cancellables)
        
        switcher
            .map({!$0})
            .assign(to: \.isHidden, on: timerView, animation: .fade(duration: 0.5))
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
                guard
                    let self = self
                else { return }
                
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
