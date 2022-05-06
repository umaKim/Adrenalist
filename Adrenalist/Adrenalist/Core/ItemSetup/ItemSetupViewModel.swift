//
//  ItemSetupViewModel.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/05/03.
//

import Foundation
import Combine

final class ItemSetupViewModel {
    
    private let workoutManager = ItemManager.shared
    private var workouts: [Item] = []
    
    private var cancellables: Set<AnyCancellable>
    
    init() {
        self.cancellables = .init()
        
        workoutManager
            .$itemToDos
            .sink {[weak self] workouts in
                guard let self = self else {return }
                self.workouts = workouts
            }
            .store(in: &cancellables)
    }
    
    func confirm(for workout: Item) {
        workouts.append(workout)
        workoutManager.updateItemToDos(workouts)
    }
}
