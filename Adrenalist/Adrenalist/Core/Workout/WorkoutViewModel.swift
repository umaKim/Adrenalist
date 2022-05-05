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
    case updateInlineStrokeEnd(CGFloat)
    case updateOutlineStrokeEnd(CGFloat)
    case updatePulse(CGFloat)
    case updateToCurrentWorkout(Item?)
    case updateNextWorkout(Item?)
}

final class WorkoutViewModel {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<WorkoutTransition, Never>()
    
    private(set) lazy var listenPublisher = listenSubject.eraseToAnyPublisher()
    private let listenSubject = PassthroughSubject<WorkoutViewModelListener, Never>()
    
    private var cancellables: Set<AnyCancellable>
    
    private(set) lazy var items: [Item] = []
    private var onGoingTime: Double = 0
    
    init() {
        self.cancellables = .init()
        bind()
    }
    
    private let workoutManager = ItemManager.shared
    
    private var currentIndex = 0
    
    private func bind() {
        workoutManager
            .$itemToDos
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .sink { workouts in
                self.items = workouts
                self.sendViewUpdate()
            }
            .store(in: &cancellables)
    }
    
    //MARK: - Public Methods
    func didTapSetting() {
        transitionSubject.send(.setting)
    }
    
    func didTapCalendar() {
        transitionSubject.send(.calendar)
    }
    
    func didDoubleTap() {
        switch items[currentIndex].type {
        case .workout:
            self.completeCurrentWorkout()
            self.workoutManager.updateItemToDos(items)
            self.sendViewUpdate()
            
        case .timer:
            self.startTimer()
        }
    }
    
    private var timer: Timer?
    
    private func startTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 1,
                                          target: self,
                                          selector: #selector(timeTics),
                                          userInfo: nil,
                                          repeats: true)
    }
    
    @objc
    private func timeTics() {
        onGoingTime += 1
        guard let countUpTo = items[currentIndex].timer else {return }
        listenSubject.send(.updateInlineStrokeEnd(onGoingTime/countUpTo))
        
        if onGoingTime == countUpTo + 1 {
            timer?.invalidate()
            onGoingTime = 0
            listenSubject.send(.updateInlineStrokeEnd(onGoingTime))
            completeCurrentWorkout()
            workoutManager.updateItemToDos(items)
            sendViewUpdate()
        }
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
        for index in 0..<items.count {
            if index == intendedIndex {
                items[index].isDone = true
                return
            }
        }
    }
    
    private func updateCurrentIndex() {
       currentIndex += 1
    }
    
    private var currentWorkout: Item? {
        for currentindex in 0..<items.count {
            if items[currentindex].isDone == false {
                self.currentIndex = currentindex
                return items[currentindex]
            }
        }
        return items.last
    }
    
    private var nextWorkout: Item? {
        if currentIndex == items.count || items.isEmpty { return nil }
        
        var workOut: [Item] = []
        var currentIndex = currentIndex
        currentIndex += 1
        
        for index in currentIndex..<items.count {
            workOut.append(items[index])
        }
        return workOut.filter { $0.isDone == false}.first
    }
    
    private var progressPulse: CGFloat {
        if items.isEmpty { return 0 }
        let finishedWorkout = CGFloat(items.filter({$0.isDone}).count)
        let totalWorkout = CGFloat(items.count)
        return 0.2 >= finishedWorkout / totalWorkout ? 0.2 : finishedWorkout / totalWorkout
    }
    
    private var progressOutline: CGFloat {
        if items.isEmpty { return 0 }
        let numberOfDone = CGFloat(items.filter({$0.isDone}).count)
        let total = CGFloat(items.count)
        return numberOfDone / total
    }
}


