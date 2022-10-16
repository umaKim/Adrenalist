//
//  File.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/07/07.
//

import Combine
import Foundation

enum FavoriteSetListViewModelNotification {
    case reload
}

class FavoriteSetListViewModel {
    
    private(set) lazy var notifyPublisher = notifySubject.eraseToAnyPublisher()
    private let notifySubject = PassthroughSubject<FavoriteSetListViewModelNotification, Never>()
    
    private(set) var response: WorkoutResponse
    private(set) var workoutList: [WorkoutModel]
    
    private(set) var mode: WorkoutListCellMode
    
    init(
        with response: WorkoutResponse
    ) {
        self.mode = .none
        self.cancellables = .init()
        self.response = response
        self.workoutList = response.workouts
        
        favoriteManager
            .$favorites
            .sink { responses in
                let index = responses.firstIndex(where: {$0.uuid == response.uuid})!
                self.response = responses[index]
                self.workoutList = responses[index].workouts
                self.notifySubject.send(.reload)
            }
            .store(in: &cancellables)
    }
    
    private var cancellables: Set<AnyCancellable>
    
    private let favoriteManager = FavoriteSetManager.shared
    
    public func changeMode(_ mode: WorkoutListCellMode) {
        
        self.mode = mode
        
        var workouts = [WorkoutModel]()
        
        workoutList.forEach { model in
            workouts.append(.init(
                title: model.title,
                reps: model.reps,
                weight: model.weight,
                timer: model.timer,
                isFavorite: model.isFavorite,
                isSelected: model.isSelected,
                isDone: model.isDone))
        }
        
        workoutList = initializeSelectedWorkout(workouts)
        
        notifySubject.send(.reload)
    }
    
    private func initializeSelectedWorkout(_ workouts: [WorkoutModel]) -> [WorkoutModel] {
        var workouts = workouts
        
        for index in 0..<workouts.count {
            workouts[index].isSelected = false
        }
        return workouts
    }
    
    public func delete() {
        self.workoutList.removeAll(where: {$0.isSelected == true})
        favoriteManager.setWorkouts(with: workoutList, of: response)
//        self.notifySubject.send(.reload)
    }
    
    public func editWorkout(with workout: WorkoutModel?) {
        guard let workout = workout else { return }
        favoriteManager.setWorkout(with: workout, of: response)
    }
    
    public func setupWorkout(with workouts: [WorkoutModel]) {
        self.workoutList.append(contentsOf: workouts)
        self.favoriteManager.addWorkouts(with: workouts, of: response)
    }
    
    public func updateIsComplete(_ isSelected: Bool, at index: Int) {
        switch mode {
        case .delete:
            self.workoutList[index].isSelected = isSelected
            
        default:
            break
        }
    }
}
