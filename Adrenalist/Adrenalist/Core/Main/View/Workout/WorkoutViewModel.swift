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
    
    private let workoutManager = WorkoutManager.shared
    
    private var currentIndex = 0
    
    private func bind() {
        workoutManager
            .$workOutToDos
            .sink { workouts in
                self.workouts = workouts
                self.sendViewUpdate()
            }
            .store(in: &cancellables)
//        workoutManager.setCurrentIndex()
    }
    
    //MARK: - Public Methods
    func didTapSetting() {
        transitionSubject.send(.setting)
    }
    
    func didTapCalendar() {
        transitionSubject.send(.calendar)
    }
    
    func didDoubleTap() {
        completeCurrentWorkout()
        workoutManager.updateWorkoutToDos(workouts)
        sendViewUpdate()
    }
    
    //MARK: - Private Methods
    private func sendViewUpdate() {
        listenSubject.send(.updatePulse(progressPulse))
        listenSubject.send(.updateOutlineStrokeEnd(progressOutline))
        listenSubject.send(.updateToCurrentWorkout(currentWorkout))
        listenSubject.send(.updateNextWorkout(nextWorkout))
    }
    
    private func completeCurrentWorkout() {
        let intendedIndex = currentIndex
        updateCurrentIndex()
        for index in 0..<workouts.count {
            if index == intendedIndex {
                workouts[index].isDone = true
                return
            }
        }
    }
    
    private func updateCurrentIndex() {
       currentIndex += 1
    }
    
    private var currentWorkout: Workout? {
        for currentindex in 0..<workouts.count {
            if workouts[currentindex].isDone == false {
                self.currentIndex = currentindex
                return workouts[currentindex]
            }
        }
        return workouts.last
    }
    
    private var nextWorkout: Workout? {
        if currentIndex == workouts.count || workouts.isEmpty { return nil }
        
        var workOut: [Workout] = []
        var currentIndex = currentIndex
        currentIndex += 1
        
        for index in currentIndex..<workouts.count {
            workOut.append(workouts[index])
        }
        return workOut.filter { $0.isDone == false}.first
    }
    
    private var progressPulse: CGFloat {
        if workouts.isEmpty { return 0 }
        let finishedWorkout = CGFloat(workouts.filter({$0.isDone}).count)
        let totalWorkout = CGFloat(workouts.count)
        return 0.2 >= finishedWorkout / totalWorkout ? 0.2 : finishedWorkout / totalWorkout
    }
    
    private var progressOutline: CGFloat {
        if workouts.isEmpty { return 0 }
        let numberOfDone = CGFloat(workouts.filter({$0.isDone}).count)
        let total = CGFloat(workouts.count)
        return numberOfDone / total
    }
}


