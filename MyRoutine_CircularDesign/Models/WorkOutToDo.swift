//
//  WorkOut.swift
//  MyRoutine_CircularDesign
//
//  Created by 김윤석 on 2021/04/02.
//

import Foundation

//struct WorkOutCollection: Codable {
//    var workOutsInADay: [WorkOutInADay]
//}

struct WorkOutWithDate: Codable {
    var selectedDateWorkOutWithTime = [String : [WorkOutWithTime]]()
}

struct WorkOutWithTime: Codable {
    var time: String
    var workOut: [WorkOut]
}

struct WorkOut: Codable, Equatable {
    var workOutName: String
    var reps: Int
    var weights: Double
    var isDone: Bool
    
    init(time: String, contents: String, reps: Int, weights: Double, isCompleted: Bool) {
        self.workOutName = contents
        self.reps = reps
        self.weights = weights
        self.isDone = isCompleted
    }
}

struct TimeToBeSaved: Codable {
    var countUptoThisSec: Int = 0
    var exitDateTime: Date?
}


