//
//  WorkOutListManager.swift
//  MyRoutine_CircularDesign
//
//  Created by 김윤석 on 2021/04/02.
//

import UIKit

class WorkOutToDoManager {
    static let shared = WorkOutToDoManager()
    
    var workOutToDos: [WorkOut] = []
    
    var currentIndex: Int?
    
    var donePercentage: CGFloat?
    
    var weightStandard = "Kg"
    
    func createWorkOutTodo(_ contents: String, reps: Int, weight: Double) {
        workOutToDos.append(WorkOut(time: Date().description(with: .current), contents: contents, reps: reps, weights: weight, isCompleted: false))
    }
    
    func calculateDonePercentage() {
        let numerator = CGFloat(workOutToDos.filter { $0.isDone }.count)
        let denominator = CGFloat(workOutToDos.count)
        
        donePercentage = (numerator / denominator) * 100.0
    }
    
    func getUnfinishedWorkOut()-> [WorkOut] {
        return workOutToDos.filter { $0.isDone == false }
    }
    
    func getFinishedWorkOut()-> [WorkOut] {
        return workOutToDos.filter { $0.isDone == true }
    }
    
    func getPreviousWorkOut()-> WorkOut? {
        return nil
    }
    
    func getNextWorkOut()-> WorkOut? {
        if currentIndex == workOutToDos.count {
            return nil
        }
        
        var workOut: [WorkOut] = []
        guard var currentIndex = currentIndex else { return nil }
        currentIndex += 1
        
        for index in currentIndex..<workOutToDos.count {
            workOut.append(workOutToDos[index])
        }
        return workOut.filter { $0.isDone == false}.first
    }
    
    func getCurrentWorkOut() -> WorkOut? {
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
        
        for index in 0..<workOutToDos.count {
            if index == intendedIndex{
                workOutToDos[index].isDone = true
            }
        }
    }
    
    func getTotalVolume() -> Double? {
        //let repsAndVolume = workOutToDos.map { Double($0.reps) * $0.weights}
        //let result = repsAndVolume.reduce(0.0) { (s1: Double, s2: Double) -> Double in return s1 + s2 }
        
        let finishedWorkout = workOutToDos.filter { $0.isDone }
        let repsAndWeights = finishedWorkout.map { Double($0.reps) * $0.weights }
        let volume = repsAndWeights.reduce(0.0) { (s1:Double, s2:Double) -> Double in
            return s1 + s2 }
        return volume
    }
    
    private init(){}
}
