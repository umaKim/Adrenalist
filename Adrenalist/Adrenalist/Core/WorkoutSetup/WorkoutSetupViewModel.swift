//
//  WorkoutSetupViewModel.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/06/16.
//

import Combine
import Foundation

class WorkoutSetupViewModel {
    
    private(set) var workout: WorkoutModel?
    
    private var title: String = ""
    private var isFavorite: Bool = false
    private var reps: Int = 0
    private var weight: Double = 0
    private var timer: TimeInterval = 0
    private var set: Int = 1
    
    private var cancellables: Set<AnyCancellable>
    
    init(
        workout: WorkoutModel? = nil
    ) {
        self.workout = workout
        self.cancellables = .init()
    }
    
    func setTitle(_ text: String) {
        self.title = text
    }
    
    func setReps(_ text: String) {
        self.reps = Int(text) ?? 0
    }
    
    func setWeight(_ text: String) {
        self.weight = Double(text) ?? 0
    }
    
    func setTimer(_ text: String) {
        self.timer = TimeInterval(text) ?? 0
    }
    
    func setSet(_ text: String) {
        self.set = Int(text) ?? 0
    }
    
    func setFavorite(_ isFavorite: Bool) {
        self.isFavorite = isFavorite
    }
    
    func doneDidTap() {
        WorkoutManager.shared.retrieveWorkoutList(of: Date().stripTime())
            .sink { comp in
                
            } receiveValue: { workouts in
                var response = WorkoutResponse(date: Date().stripTime(),
                                               workouts: workouts)
                
                let newWorkout = Array(repeating: WorkoutModel(uuid: UUID(),
                                                               mode: .normal,
                                                               title: self.title,
                                                               reps: self.reps,
                                                               weight: self.weight,
                                                               timer: self.timer,
                                                               isFavorite: self.isFavorite,
                                                               isSelected: false,
                                                               isDone: false),
                                       count: self.set)
                
                response.workouts.append(contentsOf: newWorkout)
                WorkoutManager.shared.saveWorkoutList(response)
            }
            .store(in: &cancellables)
        
        if isFavorite {
            WorkoutManager.shared.retrieveFavorites().sink { comp in
                
            } receiveValue: { workouts in
                var workouts = workouts
                workouts.append(WorkoutModel(uuid: UUID(), mode: .normal, title: self.title, reps: self.reps, weight: self.weight, timer: self.timer, isFavorite: self.isFavorite, isSelected: false, isDone: false))
                WorkoutManager.shared.saveFavorite(of: workouts)
            }
            .store(in: &cancellables)
        }
    }
}
