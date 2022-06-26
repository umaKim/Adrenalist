//
//  ItemSetupView.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/05/03.
//

import CombineCocoa
import Combine
import UIKit.UIView

enum ItemType: String, Codable {
    case workout = "Workout"
    case timer = "Timer"
}

enum ItemSetupViewAction {
    case confirm(WorkoutModel)
    case cancel
}

final class ItemSetupView: UIView {
    
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<ItemSetupViewAction, Never>()
    
    private let containerView = ItemSetupContainerView()
    
    private var cancellables: Set<AnyCancellable>
    
    init() {
        self.cancellables = .init()
        super.init(frame: .zero)
        
        bind()
        addTapGestureToViewForKeyboardDismiss()
    }
   
    override func layoutSubviews() {
        super.layoutSubviews()
        setupUI()
    }
    
    func updateUI(with item: WorkoutModel?) {
//        containerView.updateUI(with: item)
    }
    
    private func bind() {
        containerView
            .actionPublisher
            .sink { action in
                switch action {
                case .cancel:
                    self.actionSubject.send(.cancel)
                    
                case .confirm(let item):
                    self.actionSubject.send(.confirm(item))
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        backgroundColor = .black.withAlphaComponent(0.7)
        layer.cornerRadius = 12
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
