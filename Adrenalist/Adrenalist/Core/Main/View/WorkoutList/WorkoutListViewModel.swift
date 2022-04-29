//
//  WorkoutListViewModel.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/04/28.
//

import Foundation
import Combine

struct Workout: Codable {
    var uuid = UUID().uuidString
    let title: String
    let reps: String
    let weight: Double
    var isDone: Bool
}

final class WorkoutListViewModel  {
    
    lazy var suggestions: [Workout] = [
        .init(uuid: UUID().uuidString,
              title: "bench",
              reps: "10",
              weight: 100,
              isDone: false),
        .init(uuid: UUID().uuidString,
              title: "squat",
              reps: "10",
              weight: 100,
              isDone: false),
        .init(uuid: UUID().uuidString,
              title: "pull up",
              reps: "10",
              weight: 100,
              isDone: false),
        .init(uuid: UUID().uuidString,
              title: "dead lift",
              reps: "10",
              weight: 100,
              isDone: false)
    ]
    
    lazy var workouts: [Workout] = [
        .init(uuid: UUID().uuidString,
              title: "dead lift",
              reps: "10",
              weight: 100,
              isDone: false)
    ]
    
    private var cancellables: Set<AnyCancellable>
    
    init() {
        self.cancellables = .init()
//        bind()
    }
    
    private func bind() {
        WorkOutToDoManager.shared
            .$workOutToDos
            .sink { workouts in
                self.workouts = workouts
            }
            .store(in: &cancellables)
    }
    
    func didTapCell(at index: Int) {
        //        workouts.remove(at: index)
        
    }
    
    func didTapAddWorkoutButton() {
        self.workouts.append(.init(title: "Bench", reps: "10", weight: 100, isDone: false))
        WorkOutToDoManager.shared.workOutToDos = workouts
    }
}
