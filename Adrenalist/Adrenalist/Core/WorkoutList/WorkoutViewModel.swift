//
//  WorkoutListViewModel.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/04/27.
//

import Combine
import CoreFoundation
import UIKit

enum WorkoutListTransition {
    case setting
    case calendar
}

enum WorkoutListViewModelNotification {
}

final class WorkoutListViewModel {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<WorkoutListTransition, Never>()
    
    private(set) lazy var notifyPublisher = notifySubject.eraseToAnyPublisher()
    private let notifySubject = PassthroughSubject<WorkoutListViewModelNotification, Never>()
    
    private var cancellables: Set<AnyCancellable>
    
    private(set) var favorites = [WorkoutModel]()
    private(set) var workouts = [WorkoutModel]()
    
    init() {
        self.cancellables = .init()
        
        ["Bench Press",
         "pull up",
         "nice",
         "Incline Bench press",
         "Bench Press",
          "pull up",
          "nice",
          "Incline Bench press",
         "Bench Press",
          "pull up",
          "nice",
          "Incline Bench press"]
            .forEach { text in
                workouts.append(WorkoutModel(title: text,
                                          reps: 20,
                                          weight: 200,
                                          timer: 1000,
                                          isFavorite: nil))
            }
        
        ["Bench Press",
         "pull up",
         "nice",
         "Incline Bench press",
         "Bench Press",
          "pull up",
          "nice",
          "Incline Bench press",
         "Bench Press",
          "pull up",
          "nice",
          "Incline Bench press"]
            .forEach { text in
                favorites.append(WorkoutModel(title: text,
                                          reps: 20,
                                          weight: 200,
                                          timer: 1000,
                                          isFavorite: nil))
            }
    }
}
//
//final class WorkoutListViewModel2 {
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
