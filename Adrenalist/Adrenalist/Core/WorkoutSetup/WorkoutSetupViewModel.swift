//
//  WorkoutSetupViewModel.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/06/16.
//

import Combine
import Foundation

enum WorkoutSetupViewModelNotification {
    
}

enum WorkoutSetupType: String {
    case edit = "Edit"
    case add = "Add"
}

class WorkoutSetupViewModel {
    
    private(set) lazy var notifyPublisher = notifySubject.eraseToAnyPublisher()
    private let notifySubject = PassthroughSubject<WorkoutSetupViewModelNotification, Never>()
    
    private(set) var workout: WorkoutModel?
    
    private(set) var type: WorkoutSetupType
    
    private var title: String = ""
    private var isFavorite: Bool = false
    private var reps: Int = 0
    private var weight: Double = 0
    private var timer: TimeInterval = 0
    private(set) var set: Int = 1
    
    private var cancellables: Set<AnyCancellable>
    
    init(
        workout: WorkoutModel? = nil,
        type: WorkoutSetupType
    ) {
        self.workout = workout
        self.type = type
        self.cancellables = .init()
        
        // If given workout exist,
        // set the variables with the given workout
        // example case: didSelect cell for editing purpose
        if let workout = workout {
            title = workout.title
            isFavorite = false
            reps = workout.reps ?? 0
            weight = workout.weight ?? 0
            timer = workout.timer ?? 0
            set = 1
        }
    }
    
    func setTitle(_ text: String) {
        self.title = text
    }
    
    func setReps(_ text: String) {
        self.reps = Int(text) ?? 0
    }
    
    func setWeight(_ text: String) {
        self.weight = Double(text) ?? 0
    }
    
    func setTimer(_ text: String) {
        self.timer = TimeInterval(text) ?? 0
    }
    
    func setSet(_ text: String) {
        self.set = Int(text) ?? 0
    }
    
    func setFavorite(_ isFavorite: Bool) {
        self.isFavorite = isFavorite
    }
    
    func doneButtonDidTap() {
        switch type {
        case .edit:
            guard let uuid = workout?.uuid else { return }
            
            self.workout = .init(uuid: uuid,
                                 title: title,
                                 reps: reps,
                                 weight: weight,
                                 timer: timer,
                                 isFavorite: isFavorite,
                                 isSelected: workout?.isSelected ?? false,
                                 isDone: workout?.isDone ?? false)
        case .add:
            self.workout = .init(uuid: UUID(),
                                 title: title,
                                 reps: reps,
                                 weight: weight,
                                 timer: timer,
                                 isFavorite: isFavorite,
                                 isSelected: workout?.isSelected ?? false,
                                 isDone: workout?.isDone ?? false)
        }
    }
}
