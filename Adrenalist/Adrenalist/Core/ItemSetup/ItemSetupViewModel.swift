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
//    private(set) lazy var listenerPublisher = listenerSubject.eraseToAnyPublisher()
//    private let listenerSubject = PassthroughSubject<ItemSetupViewModelListen, Never>()
    
    private let workoutManager = ItemManager.shared
    
    private(set) var workout: Item?
    private var collectionViewType: CollectionViewType
    
    private var cancellables: Set<AnyCancellable>
    
    init(workout: Item? = nil, collectionViewType: CollectionViewType) {
        self.workout = workout
        self.collectionViewType = collectionViewType
        self.cancellables = .init()
        
//        listenerSubject.send(.item(workout))
    }
    
    func confirm(for workout: Item) {
        if self.workout != nil {
            switch collectionViewType {
            case .suggestion:
                var suggestions = workoutManager.suggestions
                guard let index = suggestions.firstIndex(where: {$0.uuid == workout.uuid}) else {return }
                suggestions[index] = workout
                workoutManager.updateSuggestions(suggestions)
                
            case .mainWorkout:
                var workouts = workoutManager.itemToDos
                guard let index = workouts.firstIndex(where: {$0.uuid == workout.uuid}) else {return }
                workouts[index] = workout
                workoutManager.updateWorkoutToDos(workouts)
            }
            
        } else {
            workoutManager.appendWorkoutToDos(workout)
        }
    }
    
    private func update() {
        
    }
    
    private func create() {
        
    }
}
