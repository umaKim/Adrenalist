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
    }
}
