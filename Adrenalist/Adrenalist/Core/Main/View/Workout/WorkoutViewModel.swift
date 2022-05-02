//
//  WorkoutViewModel.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/04/27.
//

import Combine
import CoreFoundation
import UIKit

enum WorkoutTransition {
    case setting
    case calendar
}

enum WorkoutViewModelListener {
    case updateOutlineStrokeEnd(CGFloat)
    case updatePulse(CGFloat)
    case updateToCurrentWorkout(Workout?)
    case updateNextWorkout(Workout?)
}

final class WorkoutViewModel {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<WorkoutTransition, Never>()
    
    private(set) lazy var listenPublisher = listenSubject.eraseToAnyPublisher()
    private let listenSubject = PassthroughSubject<WorkoutViewModelListener, Never>()
    
    private var cancellables: Set<AnyCancellable>
    
    private(set) lazy var workouts: [Workout] = []
    
    init() {
        self.cancellables = .init()
        bind()
    }
    
    private let workout = WorkOutToDoManager.shared
    
    private func bind() {
        workout
            .$workOutToDos
            .sink { workouts in
                self.workouts = workouts
                self.sendViewUpdate()
            }
            .store(in: &cancellables)
        
        workout.setCurrentIndex()
    }
    
    //MARK: - Public Methods
    func didTapSetting() {
        transitionSubject.send(.setting)
    }
    
    func didTapCalendar() {
        transitionSubject.send(.calendar)
    }
    
    func didDoubleTap() {
        workout.completeCurrentWorkOut()
        sendViewUpdate()
    }
    
    //MARK: - Private Methods
    private func sendViewUpdate() {
        listenSubject.send(.updatePulse(progressPulse))
        listenSubject.send(.updateOutlineStrokeEnd(progressOutline))
        listenSubject.send(.updateToCurrentWorkout(currentWorkout))
        listenSubject.send(.updateNextWorkout(nextWorkout))
    }
    
    private var currentWorkout: Workout? {
        return workout.getCurrentWorkOut()
    }
    
    private var nextWorkout: Workout? {
        return workout.getNextWorkOut()
    }
    
    private var progressPulse: CGFloat {
        if workout.workOutToDos.count == 0 {
            return 0
        }
        
        let finishedWorkout = CGFloat(workout.getUnfinishedWorkOut().count)
        let totalWorkout = CGFloat(workout.workOutToDos.count)
        return 0.2 >= finishedWorkout / totalWorkout ? 0.2 : finishedWorkout / totalWorkout
    }
    
    private var progressOutline: CGFloat {
        if workouts.count == 0 { return 0}
        let numberOfDone = CGFloat(workouts.filter({$0.isDone}).count)
        let total = CGFloat(workouts.count)
        return (numberOfDone / total)
    }
}


