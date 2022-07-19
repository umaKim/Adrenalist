//
//  SetupFavoriteSetViewModel.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/07/12.
//
import Combine
import Foundation

enum SetupFavoriteSetViewModelNotify {
    case reload
}

class SetupFavoriteSetViewModel {
    private(set) lazy var notifyPublisher = notifySubject.eraseToAnyPublisher()
    private let notifySubject = PassthroughSubject<SetupFavoriteSetViewModelNotify, Never>()
    
    private(set) var setName: String = ""
    private(set) var workoutList = [WorkoutModel]()
    private(set) var mode: WorkoutListCellMode
    
    private let response: WorkoutResponse?
    
    private let favoriteManager = FavoriteSetManager.shared
    
    private let type: WorkoutSetupType
    
    init(
        _ response: WorkoutResponse? = nil,
        type: WorkoutSetupType
    ) {
        self.response = response
        self.mode = .none
        self.type = type
        
        setName = response?.name ?? ""
        workoutList = response?.workouts ?? []
    }
    
    public func editWorkout(with workout: WorkoutModel?) {
        guard
            let workout = workout,
            let index = self.workoutList.firstIndex(where: {$0.uuid == workout.uuid})
        else { return }
        self.workoutList[index] = workout
//        workoutManager.setWorkoutlist(with: workoutList)
        self.notifySubject.send(.reload)
    }
    
    public func setupWorkout(with workouts: [WorkoutModel]) {
        self.workoutList.append(contentsOf: workouts)
//        self.workoutManager.setWorkoutlist(with: workoutList)
    }
    
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
    
    public func setupSetName(_ text: String) {
        self.setName = text
    }
    
    public func delete() {
        self.workoutList.removeAll(where: {$0.isSelected == true})
//        favoriteManager.setWorkouts(with: workoutList, of: response)
        self.notifySubject.send(.reload)
    }
    
    public func updateIsComplete(
        _ isSelected: Bool,
        at index: Int
    ) {
        switch mode {
        case .delete:
            self.workoutList[index].isSelected = isSelected
            
        case .createSet:
            self.workoutList[index].isSelected = isSelected
            
        case .none:
            break
            
        default:
            break
        }
    }
    
    public func didTapDone() {
        switch type {
        case .edit:
            self.doneForEdit()
            
        case .add:
            self.doneForAdd()
        }
    }
    
    private func doneForEdit() {
        var favorites = favoriteManager.favorites
        guard let uuid = response?.uuid else { return }
        let res = WorkoutResponse(uuid: uuid, name: setName, date: nil, workouts: workoutList)
        guard let index = favorites.firstIndex(where: {$0.uuid == self.response?.uuid}) else { return }
        favorites[index] = res
        favoriteManager.setFavorites(favorites)
    }
    
    private func doneForAdd() {
        favoriteManager.addFavorites(WorkoutResponse(uuid: UUID(), name: setName, date: nil, workouts: workoutList))
    }
}
