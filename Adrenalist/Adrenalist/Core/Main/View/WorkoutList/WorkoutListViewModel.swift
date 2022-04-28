//
//  WorkoutListViewModel.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/04/28.
//

import Foundation

struct Workout: Codable {
    let title: String
    let reps: String
    let weight: Double
    let isDone: Bool
}

final class WorkoutListViewModel  {
    
    private(set) lazy var workouts: [Workout] = []
    
    init() {
        workouts = PersistanceManager.shared.retrieveWorkouts()
    }
    
    func didTapCell(at index: Int) {
        workouts.remove(at: index)
    }
    
    func didTapAddWorkoutButton() {
        workouts.append(.init(title: "BenchPress", reps: "", weight: 0, isDone: true))
        PersistanceManager.shared.saveWorkouts(workouts)
    }
}
