//
//  WorkoutSetupView.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/06/16.
//

import CombineCocoa
import Combine
import UIKit

enum WorkoutSetupViewAction {
    case didTapDone
    case didTapCancel
}

class WorkoutSetupView: UIView {
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<WorkoutSetupViewAction, Never>()
    
    private(set) lazy var doneButton = UIBarButtonItem(title: "done", style: .plain, target: nil, action: nil)
    private(set) lazy var cancelButton: UIBarButtonItem = UIBarButtonItem(title: "cancel", style: .plain, target: nil, action: nil)
    
    private var cancellables: Set<AnyCancellable>
    
    init() {
        self.cancellables = .init()
        super.init(frame: .zero)
        
        doneButton
            .tapPublisher
            .sink { _ in
                self.actionSubject.send(.didTapDone)
            }
            .store(in: &cancellables)
        
        cancelButton
            .tapPublisher
            .sink { _ in
                self.actionSubject.send(.didTapCancel)
            }
            .store(in: &cancellables)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
