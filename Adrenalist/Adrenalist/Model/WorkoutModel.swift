//
//  WorkoutModel.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/06/17.
//

import Foundation

struct WorkoutResponse: Codable, Hashable {
    var uuid = UUID()
    var name: String?
    var date: Date?
    var workouts: [WorkoutModel]
}

struct WorkoutModel: Codable, Hashable {
    var uuid = UUID()
    var title: String
    var reps: Int?
    var weight: Double?
    var timer: TimeInterval?
    var isFavorite: Bool
    var isSelected: Bool
    var isDone: Bool
}

//struct WorkoutContainer: Codable {
//    var sets: [WorkoutSet]
//}
//
//struct WorkoutSet: Codable {
//    var name: String
//    var set: [WorkoutModel]
//}
