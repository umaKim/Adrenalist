//
//  Workout.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/04/30.
//

import Foundation

struct Item: Codable, Hashable {
    var uuid = UUID().uuidString
    var timer: TimeInterval?
    var title: String
    var reps: Int?
    var weight: Double?
    var isDone: Bool
    var type: ItemType
}
