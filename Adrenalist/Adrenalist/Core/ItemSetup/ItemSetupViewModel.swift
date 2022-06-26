//
//  ItemSetupViewModel.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/05/03.
//

import Foundation
import Combine

enum CollectionViewType {
    case suggestion
    case mainWorkout
}

enum ItemSetupViewModelListen {
    case item(Item?)
}

final class ItemSetupViewModel {
    private let workoutManager = Manager.shared
    
    private(set) var workout: WorkoutModel?
    private var collectionViewType: CollectionViewType
    
    private var cancellables: Set<AnyCancellable>
    
    init(workout: WorkoutModel? = nil, collectionViewType: CollectionViewType) {
        self.workout = workout
        self.collectionViewType = collectionViewType
        self.cancellables = .init()
    }
    
    func confirm(for workout: WorkoutModel) {
//        if self.workout != nil {
//            switch collectionViewType {
//            case .suggestion:
//                var suggestions = workoutManager.suggestions
//                guard let index = suggestions.firstIndex(where: {$0.uuid == workout.uuid}) else {return }
//                suggestions[index] = workout
//                workoutManager.updateSuggestions(suggestions)
//
//            case .mainWorkout:
//                var workouts = workoutManager.itemToDos
//                guard let index = workouts.firstIndex(where: {$0.uuid == workout.uuid}) else {return }
//                workouts[index] = workout
//                workoutManager.updateWorkoutToDos(workouts)
//            }
//
//        } else {
//            workoutManager.appendWorkoutToDos(workout)
//        }
    }
    
    private func update() {
        
    }
    
    private func create() {
        
    }
}
