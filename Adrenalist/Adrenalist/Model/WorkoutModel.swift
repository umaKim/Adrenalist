//
//  WorkoutModel.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/06/17.
//

import Foundation

struct WorkoutResponse: Codable {
    var date: Date
    var mode: WorkoutListCellMode
    var workouts: [WorkoutModel]
}

struct WorkoutModel: Codable, Hashable {
    var uuid = UUID()
    var title: String
    var reps: Int?
    var weight: Double?
    var timer: TimeInterval?
    var isFavorite: Bool
    var isSelected: Bool?
    var isDone: Bool
}
