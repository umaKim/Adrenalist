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
    
    private func bind() {
        WorkOutToDoManager.shared
            .$workOutToDos
            .sink { workouts in
                self.workouts = workouts
                self.sendViewUpdate()
            }
            .store(in: &cancellables)
        
        WorkOutToDoManager.shared.setCurrentIndex()
    }
    
    func didTapSetting() {
        transitionSubject.send(.setting)
    }
    
    func didTapCalendar() {
        transitionSubject.send(.calendar)
    }
    
    func didDoubleTap() {
        WorkOutToDoManager.shared.completeCurrentWorkOut()
        sendViewUpdate()
    }
    
    private func sendViewUpdate() {
        listenSubject.send(.updatePulse(progressPulse))
        listenSubject.send(.updateOutlineStrokeEnd(progressOutline))
    }
    
    private var progressPulse: CGFloat {
        if WorkOutToDoManager.shared.workOutToDos.count == 0 {
            return 0
        }
        
        let finishedWorkout = CGFloat(WorkOutToDoManager.shared.getUnfinishedWorkOut().count)
        let totalWorkout = CGFloat(WorkOutToDoManager.shared.workOutToDos.count)
        
        if 0.2 >= finishedWorkout / totalWorkout {
            return 0.2
        } else {
            return finishedWorkout / totalWorkout
        }
    }
    
    private var progressOutline: CGFloat {
        if workouts.count == 0 { return 0}
        let numberOfDone = CGFloat(workouts.filter({$0.isDone}).count)
        let total = CGFloat(workouts.count)
        return (numberOfDone / total)
    }
}


