//
//  WorkoutHistoryView.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/04/27.
//

import CombineCocoa
import Combine
import UIKit

final class WorkoutHistoryView: UIView {
    private(set) lazy var backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .done, target: nil, action: nil)
    
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<SettingViewAction, Never>()
    
    private var cancellables: Set<AnyCancellable>
    
    init() {
        self.cancellables = .init()
        super.init(frame: .zero)
        
        bind()
    }
    
    private func bind() {
        backButton
            .tapPublisher
            .sink {[weak self] _ in
                self?.actionSubject.send(.backButtonDidTap)
            }
            .store(in: &cancellables)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }    
}