//
//  WhatToDoManager.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/04/29.
//
import Combine
import UIKit

final class WorkoutManager {
    static let shared = WorkoutManager()
    
    @Published private(set) var suggestions: [Workout] = []
    @Published private(set) var workOutToDos: [Workout] = []
    
    func updateWorkoutToDos(_ workouts: [Workout]) {
        self.workOutToDos = workouts
    }
    
    func updateSuggestions(_ suggestions: [Workout]) {
        self.suggestions = suggestions
    }
    
    private init() {}
}
