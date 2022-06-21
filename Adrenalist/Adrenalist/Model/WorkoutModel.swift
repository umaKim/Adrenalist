//
//  WorkoutModel.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/06/17.
//

import Foundation

struct WorkoutResponse {
    var date: Date
    var mode: WorkoutListCellMode
    var workouts: [WorkoutModel]
}

struct WorkoutModel {
    var mode: WorkoutListCellMode
    
    var title: String
    var reps: Int?
    var weight: Double?
    var timer: TimeInterval?
    var isFavorite: Bool?
    var isSelected: Bool?
}
