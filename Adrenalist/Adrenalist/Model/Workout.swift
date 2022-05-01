//
//  Workout.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/04/30.
//

import Foundation

struct Workout: Codable {
    var uuid = UUID().uuidString
    let title: String
    let reps: String
    let weight: Double
    var isDone: Bool
}
