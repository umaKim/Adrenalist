//
//  WorkoutSetupViewModel.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/06/16.
//

import Combine
import Foundation

enum WorkoutSetupViewModelNotification {
    case doneButtonDidTap(models: [WorkoutModel], type: WorkoutSetupType)
}

enum WorkoutSetupType: String {
    case edit = "Edit"
    case add = "Add"
}

class WorkoutSetupViewModel {
    
    private(set) lazy var notifyPublisher = notifySubject.eraseToAnyPublisher()
    private let notifySubject = PassthroughSubject<WorkoutSetupViewModelNotification, Never>()
    
    private(set) var workout: WorkoutModel
    private(set) var type: WorkoutSetupType
    
    private var title: String = ""
    private var isFavorite: Bool = false
    private var reps: Int = 0
    private var weight: Double = 0
    private var timer: TimeInterval = 0
    private var set: Int = 1
    
    private var cancellables: Set<AnyCancellable>
    
    //MARK: - Init
    init(
        workout: WorkoutModel,
        type: WorkoutSetupType
    ) {
        self.workout = workout
        self.title = workout.title
        self.reps = workout.reps ?? 0
        self.weight = workout.weight ?? 0
        self.timer = workout.timer ?? 0
        self.type = type
        self.cancellables = .init()
    }
}

//MARK: - Public Methods
extension WorkoutSetupViewModel {
    public func setTitle(_ text: String) {
        self.title = text
    }
    
    public func setReps(_ text: String) {
        self.reps = Int(text) ?? 0
    }
    
    public func setWeight(_ text: String) {
        self.weight = Double(text) ?? 0
    }
    
    public func setTimer(_ text: String) {
        self.timer = TimeInterval(text) ?? 0
    }
    
    public func setSet(_ text: String) {
        self.set = Int(text) ?? 0
    }
    
    public func setFavorite(_ isFavorite: Bool) {
        self.isFavorite = isFavorite
    }
    
    public func doneButtonDidTap() {
        var workouts: [WorkoutModel] = []
        for _ in 1...set {
            workouts.append(WorkoutModel(uuid: type == .add ? UUID() : workout.uuid,
                                         title: title,
                                         reps: reps,
                                         weight: weight,
                                         timer: timer,
                                         isFavorite: isFavorite,
                                         isSelected: workout.isSelected,
                                         isDone: workout.isDone))
        }
        
        notifySubject.send(.doneButtonDidTap(models: workouts, type: type))
    }
}
