//
//  WorkoutHistoryViewModel.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/04/27.
//

import Combine

enum WorkoutHistoryTransition {
    case workout
}

final class WorkoutHistoryViewModel {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<WorkoutHistoryTransition, Never>()
    
    /// Tap for going back to workout page
    func didTapBackButton() {
        transitionSubject.send(.workout)
    }
}
