//
//  WhatToDoManager.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/04/29.
//
import Combine
import UIKit

final class WorkOutToDoManager {
    static let shared = WorkOutToDoManager()
    
    @Published var workOutToDos: [Workout] = []
    
    var currentIndex: Int?
    
    var donePercentage: CGFloat?
    
    var weightStandard = "Kg"
    
    public func setCurrentIndex() {
        if workOutToDos.isEmpty {
            currentIndex = 0
            return
        }
        
        for currentindex in 0..<workOutToDos.count {
            if workOutToDos[currentindex].isDone == false {
                self.currentIndex = currentindex
            }
        }
    }
    
    func createWorkOutTodo(_ contents: String, reps: Int, weight: Double) {
        workOutToDos.append(.init(title: contents, reps: reps, weight: weight, isDone: false))
    }
    
    func calculateDonePercentage() {
        let numerator = CGFloat(workOutToDos.filter { $0.isDone }.count)
        let denominator = CGFloat(workOutToDos.count)
        
        donePercentage = (numerator / denominator) * 100.0
    }
    
    func getUnfinishedWorkOut()-> [Workout] {
        return workOutToDos.filter { $0.isDone == false }
    }
    
    func getFinishedWorkOut()-> [Workout] {
        return workOutToDos.filter { $0.isDone == true }
    }
    
    func getPreviousWorkOut()-> Workout? {
        return nil
    }
    
    func getNextWorkOut()-> Workout? {
        if currentIndex == workOutToDos.count || workOutToDos.isEmpty {
            return nil
        }
        
        var workOut: [Workout] = []
        guard var currentIndex = currentIndex else { return nil }
        currentIndex += 1
        
        for index in currentIndex..<workOutToDos.count {
            workOut.append(workOutToDos[index])
        }
        return workOut.filter { $0.isDone == false}.first
    }
    
    func getCurrentWorkOut() -> Workout? {
        for currentindex in 0..<workOutToDos.count {
            if workOutToDos[currentindex].isDone == false {
                self.currentIndex = currentindex
                return workOutToDos[currentindex]
            }
        }
        return workOutToDos.last
    }
    
    func completeCurrentWorkOut() {
        guard let intendedIndex = currentIndex else { return }
        updateCurrentIndex()
        for index in 0..<workOutToDos.count {
            if index == intendedIndex {
                workOutToDos[index].isDone = true
            }
        }
    }
    
    private func updateCurrentIndex() {
        guard var currentIndex = currentIndex else { return }
        currentIndex += 1
        self.currentIndex = currentIndex
    }
    func update(with workouts: [Workout]) {
        self.workOutToDos = workouts
    }
    
    private init() {}
}
