//
//  AboutView.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/05/04.
//

import UIKit.UIView

enum AboutViewAction {
    case dismiss
}

final class AboutView: UIView {
    
    private(set) lazy var dismissButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .done, target: nil, action: nil)
    
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<AboutViewAction, Never>()
    
    private var cancellables: Set<AnyCancellable>
    
    init() {
        self.cancellables = .init()
        super.init(frame: .zero)
        
        backgroundColor = .black
        
        dismissButton
            .tapPublisher
            .sink { _ in
                self.actionSubject.send(.dismiss)
            }
            .store(in: &cancellables)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
