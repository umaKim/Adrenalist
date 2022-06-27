//
//  WorkoutListViewModel.swift
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
    case workoutList
}

enum WorkoutViewModelNotification {
    case updateInlineStrokeEnd(Double)
    
    case updatePulse(CGFloat)
    case updateOutlineStrokeEnd(CGFloat)
    case updateToCurrentWorkout(WorkoutModel?)
    case updateNextWorkout(WorkoutModel?)
    
}

final class WorkoutViewModel {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<WorkoutTransition, Never>()
    
    private(set) lazy var notifyPublisher = notifySubject.eraseToAnyPublisher()
    private let notifySubject = PassthroughSubject<WorkoutViewModelNotification, Never>()
    
    private var cancellables: Set<AnyCancellable>
    
//    private(set) var favorites = [WorkoutModel]()
    private(set) var workouts = [WorkoutResponse]()
    
    private(set) var todayWorkouts = [WorkoutModel]()
    
//    private(set) var isCanlendarBottomSheetPresented: Bool = false
//
//    func setCalendarBottomSheetPresent(_ isPresent: Bool) {
//        self.isCanlendarBottomSheetPresented = isPresent
//    }
    
    private let workoutManager = Manager.shared
    
    private var currentIndex: Int?
    private var isTimerGoingOn: Bool = false
    private var timer: Timer?
    private var onGoingTime: Double = 0
    
    init() {
        self.cancellables = .init()
        
        workoutManager
            .$workoutResponses
            .sink { responses in
                self.workouts = responses
            }
            .store(in: &cancellables)
    }
    
    func backToWorkoutList() {
        self.transitionSubject.send(.workoutList)
    }
    
    func didTapSkip() {
        print("Skip")
    }
    
    func didTapNext() {
        print("next")
        
        guard
            let currentIndex = currentIndex,
            currentIndex < workouts.count
        else { return }
        
        if todayWorkouts[currentIndex].timer == nil {
            self.completeCurrentWorkout()
            //TODO: update with new api
//            self.workoutManager.updateWorkoutToDos(items)
            self.sendViewUpdate()
        } else {
            self.startTimer()
        }
    }
    
    private func startTimer() {
        if isTimerGoingOn {
            timer?.invalidate()
            timer = nil
            isTimerGoingOn = false
            onGoingTime = 0
            notifySubject.send(.updateInlineStrokeEnd(onGoingTime))
            completeCurrentWorkout()
            //TODO: update with new api
//            workoutManager.updateWorkoutToDos(items)
            sendViewUpdate()
            return
        }
        
        isTimerGoingOn = true
        
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(self.timerRun),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    @objc
    private func timerRun() {
        onGoingTime += 1
        
        guard
            let currentIndex = currentIndex,
            let countUpTo = todayWorkouts[currentIndex].timer
        else { return }
        
        notifySubject.send(.updateInlineStrokeEnd(onGoingTime/countUpTo))
        
        if onGoingTime == countUpTo + 1 {
            timer?.invalidate()
            timer = nil
            isTimerGoingOn = false
            onGoingTime = 0
            notifySubject.send(.updateInlineStrokeEnd(onGoingTime))
            completeCurrentWorkout()
//            workoutManager.updateWorkoutToDos(items)
            sendViewUpdate()
        }
    }
    
    private func completeCurrentWorkout() {
        let intendedIndex = currentIndex
        updateCurrentIndex()
        for index in 0..<todayWorkouts.count {
            if index == intendedIndex {
                todayWorkouts[index].isDone = true
                return
            }
        }
    }
    
    private func updateCurrentIndex() {
        guard var currentIndex = currentIndex else { return }
        currentIndex += 1
        self.currentIndex = currentIndex
    }
    
    
    private func sendViewUpdate() {
        notifySubject.send(.updatePulse(progressPulse))
        notifySubject.send(.updateOutlineStrokeEnd(progressOutline))
        notifySubject.send(.updateToCurrentWorkout(currentWorkout))
        notifySubject.send(.updateNextWorkout(nextWorkout))
    }
    
    
    private var currentWorkout: WorkoutModel? {
        for currentindex in 0..<todayWorkouts.count {
            if todayWorkouts[currentindex].isDone == false {
                self.currentIndex = currentindex
                return todayWorkouts[currentindex]
            }
        }
        return todayWorkouts.last
    }
    
    private var nextWorkout: WorkoutModel? {
        if currentIndex == todayWorkouts.count ||
            todayWorkouts.isEmpty
        { return nil }
        
        var workOut: [WorkoutModel] = []
        guard var currentIndex = currentIndex else {return nil}
        currentIndex += 1
        
        for index in currentIndex..<todayWorkouts.count {
            workOut.append(todayWorkouts[index])
        }
        return workOut.filter { $0.isDone == false}.first
    }
    
    private var progressPulse: CGFloat {
        if todayWorkouts.isEmpty { return 0 }
        let finishedWorkout = CGFloat(todayWorkouts.filter({!$0.isDone}).count)
        let totalWorkout = CGFloat(todayWorkouts.count)
        return 0.2 >= finishedWorkout / totalWorkout ? 0.2 : finishedWorkout / totalWorkout
    }
    
    private var progressOutline: CGFloat {
        if todayWorkouts.isEmpty { return 0 }
        let numberOfDone = CGFloat(todayWorkouts.filter({$0.isDone}).count)
        let total = CGFloat(todayWorkouts.count)
        return numberOfDone / total
    }
}

//
//final class WorkoutListViewModel22 {
//    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
//    private let transitionSubject = PassthroughSubject<WorkoutListTransition, Never>()
//
//    private(set) lazy var notifyPublisher = notifySubject.eraseToAnyPublisher()
//    private let notifySubject = PassthroughSubject<WorkoutListViewModelNotification, Never>()
//
//    private var cancellables: Set<AnyCancellable>
//
//    private let workoutManager = ItemManager.shared
//
//    private var currentIndex: Int?
//    private var isTimerGoingOn: Bool = false
//    private var timer: Timer?
//    private var onGoingTime: Double = 0
//
//    private(set) lazy var items: [Item] = []
//
//    init() {
//        self.cancellables = .init()
//        bind()
//    }
//
//    //MARK: - Public Methods
//    func didTapSetting() {
//        transitionSubject.send(.setting)
//    }
//
//    func didTapCalendar() {
//        transitionSubject.send(.calendar)
//    }
//
//    func didDoubleTap() {
//        guard
//            let currentIndex = currentIndex,
//            currentIndex < items.count
//        else { return }
//
//        switch items[currentIndex].type {
//        case .workout:
//            self.completeCurrentWorkout()
//            self.workoutManager.updateWorkoutToDos(items)
//            self.sendViewUpdate()
//
//        case .timer:
//            self.startTimer()
//        }
//    }
//
//    //MARK: - Private Methods
//
//    private func bind() {
//        workoutManager
//            .$itemToDos
//            .subscribe(on: DispatchQueue.global(qos: .background))
//            .receive(on: DispatchQueue.main)
//            .sink {[weak self] workouts in
//                guard let self = self else {return }
//                self.items = workouts
//                self.sendViewUpdate()
//            }
//            .store(in: &cancellables)
//    }
//
//    private func sendViewUpdate() {
//        notifySubject.send(.updatePulse(progressPulse))
//        notifySubject.send(.updateOutlineStrokeEnd(progressOutline))
//        notifySubject.send(.updateToCurrentWorkout(currentWorkout))
//        notifySubject.send(.updateNextWorkout(nextWorkout))
//    }
//
//    private func completeCurrentWorkout() {
//        let intendedIndex = currentIndex
//        updateCurrentIndex()
//        for index in 0..<items.count {
//            if index == intendedIndex {
//                items[index].isDone = true
//                return
//            }
//        }
//    }
//
//    private func updateCurrentIndex() {
//        guard var currentIndex = currentIndex else { return }
//        currentIndex += 1
//        self.currentIndex = currentIndex
//    }
//
//    private var currentWorkout: Item? {
//        for currentindex in 0..<items.count {
//            if items[currentindex].isDone == false {
//                self.currentIndex = currentindex
//                return items[currentindex]
//            }
//        }
//        return items.last
//    }
//
//    private var nextWorkout: Item? {
//        if currentIndex == items.count || items.isEmpty { return nil }
//
//        var workOut: [Item] = []
//        guard var currentIndex = currentIndex else {return nil}
//        currentIndex += 1
//
//        for index in currentIndex..<items.count {
//            workOut.append(items[index])
//        }
//        return workOut.filter { $0.isDone == false}.first
//    }
//
//    private var progressPulse: CGFloat {
//        if items.isEmpty { return 0 }
//        let finishedWorkout = CGFloat(items.filter({!$0.isDone}).count)
//        let totalWorkout = CGFloat(items.count)
//        return 0.2 >= finishedWorkout / totalWorkout ? 0.2 : finishedWorkout / totalWorkout
//    }
//
//    private var progressOutline: CGFloat {
//        if items.isEmpty { return 0 }
//        let numberOfDone = CGFloat(items.filter({$0.isDone}).count)
//        let total = CGFloat(items.count)
//        return numberOfDone / total
//    }
//
//
//    private func startTimer() {
//        if isTimerGoingOn {
//            timer?.invalidate()
//            timer = nil
//            isTimerGoingOn = false
//            onGoingTime = 0
//            notifySubject.send(.updateInlineStrokeEnd(onGoingTime))
//            completeCurrentWorkout()
//            workoutManager.updateWorkoutToDos(items)
//            sendViewUpdate()
//            return
//        }
//
//        isTimerGoingOn = true
//
//        timer = Timer.scheduledTimer(timeInterval: 1,
//                                     target: self,
//                                     selector: #selector(self.timerRun),
//                                     userInfo: nil,
//                                     repeats: true)
//    }
//
//    @objc
//    private func timerRun() {
//        onGoingTime += 1
//
//        guard
//            let currentIndex = currentIndex,
//            let countUpTo = items[currentIndex].timer
//        else { return }
//
//        notifySubject.send(.updateInlineStrokeEnd(onGoingTime/countUpTo))
//
//        if onGoingTime == countUpTo + 1 {
//            timer?.invalidate()
//            timer = nil
//            isTimerGoingOn = false
//            onGoingTime = 0
//            notifySubject.send(.updateInlineStrokeEnd(onGoingTime))
//            completeCurrentWorkout()
//            workoutManager.updateWorkoutToDos(items)
//            sendViewUpdate()
//        }
//    }
//}
