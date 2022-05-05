//
//  SettingViewModel.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/04/27.
//

import Combine

enum SettingTransition {
    case workout
}

final class SettingViewModel {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<SettingTransition, Never>()
    
    private(set) lazy var models = ["Correct", "About"]
    
    func didTapBackButton() {
        transitionSubject.send(.workout)
    }
}
