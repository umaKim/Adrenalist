//
//  File.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/07/07.
//

import Combine

enum FavoriteSetListViewModelNotification {
    
}

class FavoriteSetListViewModel {
    
    private lazy var notifyPublisher = notifySubject.eraseToAnyPublisher()
    private let notifySubject = PassthroughSubject<FavoriteSetListViewModelNotification, Never>()
    
    private(set) var response: WorkoutResponse
    
    init(with response: WorkoutResponse) {
        self.response = response
    }
}
