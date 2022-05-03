//
//  ItemSetupViewModel.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/05/03.
//

import Foundation
import Combine

final class ItemSetupViewModel {
    
    private let workoutManager = WorkoutManager.shared
    private var workouts: [Workout] = []
    
    private var cancellables: Set<AnyCancellable>
    
    init() {
        self.cancellables = .init()
        
        workoutManager
            .$workOutToDos
            .sink { workouts in
                self.workouts = workouts
            }
            .store(in: &cancellables)
    }
    
    func confirm(for workout: Workout) {
        workouts.append(workout)
        workoutManager.updateWorkoutToDos(workouts)
    }
}
